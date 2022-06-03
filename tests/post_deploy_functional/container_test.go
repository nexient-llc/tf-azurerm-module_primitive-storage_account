package test

import (
	"fmt"
	"path"
	"testing"

	"github.com/gruntwork-io/go-commons/files"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/mitchellh/mapstructure"
	"github.com/stretchr/testify/suite"
)

// Define the suite, and absorb the built-in basic suite
// functionality from testify - including a T() method which
// returns the current testing context
type TerraTestSuite struct {
	suite.Suite
	TerraformOptions *terraform.Options
}

type StorageContainer struct {
	Name                string `mapstructure:"name"`
	ContainerAccessType string `mapstructure:"container_access_type"`
}

type ResourceGroup struct {
	Name     string `mapstructure:"name"`
	Location string `mapstructure:"location"`
}

type StorageAccount struct {
	AccountTier            string `mapstructure:"account_tier"`
	AccountReplicationType string `mapstructure:"account_replication_type"`
}

// setup to do before any test runs
func (suite *TerraTestSuite) SetupSuite() {
	tmpDir := test_structure.CopyTerraformFolderToTemp(suite.T(), "../..", ".")
	_ = files.CopyFile(path.Join("..", "..", ".tool-versions"), path.Join(tmpDir, ".tool-versions"))
	suite.TerraformOptions = terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: tmpDir,
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"resource_group": map[string]interface{}{
				"name":     "deb-test-devops",
				"location": "EastUS",
			},
			"storage_account_name": "functionappstorage1a123",
			"storage_account": map[string]interface{}{
				"account_tier":             "Standard",
				"account_replication_type": "LRS",
				"tags": map[string]interface{}{
					"environment": "dev",
					"creator":     "Nexient Team",
				},
			},
			"storage_containers": map[string]interface{}{
				"functionappstorage1a123": map[string]interface{}{
					"name":                  "testcontainer",
					"container_access_type": "private",
				},
			},
		},
	})
	terraform.InitAndApplyAndIdempotent(suite.T(), suite.TerraformOptions)
}

// TearDownAllSuite has a TearDownSuite method, which will run after all the tests in the suite have been run.
func (suite *TerraTestSuite) TearDownSuite() {
	terraform.Destroy(suite.T(), suite.TerraformOptions)
}

// In order for 'go test' to run this suite, we need to create
// a normal test function and pass our suite to suite.Run
func TestRunSuite(t *testing.T) {
	suite.Run(t, new(TerraTestSuite))
}

func (suite *TerraTestSuite) TestContainers() {
	// NOTE: "subscriptionID" is overridden by the environment variable "ARM_SUBSCRIPTION_ID". <>
	subscriptionID := ""

	testA_inputStorageContainer := StorageContainer{
		Name:                "test-storage-container",
		ContainerAccessType: "private",
	}

	inputResourceGroup := ResourceGroup{
		Name:     "deb-test-devops",
		Location: "East US",
	}

	inputStorageAccount := StorageAccount{
		AccountTier:            "Standard",
		AccountReplicationType: "LRS",
	}

	var options map[string]interface{}
	err := mapstructure.Decode(inputStorageAccount, &options)
	if err != nil {
		suite.T().Fatal(err)
	}

	var testA_containerOptions map[string]interface{}
	err = mapstructure.Decode(testA_inputStorageContainer, &testA_containerOptions)
	if err != nil {
		suite.T().Fatal(err)
	}

	options["storage_containers"] = map[string]interface{}{
		"test-a": testA_containerOptions,
	}

	var resourceGroupOptions map[string]interface{}
	err = mapstructure.Decode(inputResourceGroup, &resourceGroupOptions)
	if err != nil {
		suite.T().Fatal(err)
	}

	var outputStorageAccount StorageAccount
	terraform.OutputStruct(suite.T(), suite.TerraformOptions, "storage_account", &outputStorageAccount)

	var outputStorageContainers map[string]StorageContainer
	err = mapstructure.Decode(
		terraform.OutputMapOfObjects(suite.T(), suite.TerraformOptions, "storage_containers"),
		&outputStorageContainers,
	)
	if err != nil {
		suite.T().Fatal(err)
	}

	storageAccoutName := "functionappstorage1a123"

	storageAccountExists := azure.StorageAccountExists(suite.T(), storageAccoutName, inputResourceGroup.Name, subscriptionID)
	suite.True(storageAccountExists, "storage account does not exist")
	actualDNSString := azure.GetStorageDNSString(suite.T(), storageAccoutName, inputResourceGroup.Name, subscriptionID)
	storageSuffix, _ := azure.GetStorageURISuffixE()
	expectedDNS := fmt.Sprintf("https://%s.blob.%s/", storageAccoutName, storageSuffix)
	suite.Equal(expectedDNS, actualDNSString, "Storage DNS string mismatch")

	for _, outputStorageContainer := range outputStorageContainers {
		containerExists := azure.StorageBlobContainerExists(suite.T(), outputStorageContainer.Name, storageAccoutName, inputResourceGroup.Name, subscriptionID)
		suite.True(containerExists, "storage container does not exist")

		publicAccess := azure.GetStorageBlobContainerPublicAccess(suite.T(), outputStorageContainer.Name, storageAccoutName, inputResourceGroup.Name, subscriptionID)
		suite.False(publicAccess, "storage container has public access")
	}
}
