package common

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	armStorage "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/nexient-llc/lcaf-component-terratest-common/lib/azure/login"
	"github.com/nexient-llc/lcaf-component-terratest-common/types"
	"github.com/stretchr/testify/assert"
)

func TestStorageAccount(t *testing.T, ctx types.TestContext) {

	envVarMap := login.GetEnvironmentVariables()
	subscriptionID := envVarMap["subscriptionID"]

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	storageAccountClient, err := armStorage.NewAccountsClient(subscriptionID, credential, &options)
	if err != nil {
		t.Fatalf("Error getting Storage Account client: %v", err)
	}

	t.Run("doesStorageAccountExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		storageAccountName := terraform.Output(t, ctx.TerratestTerraformOptions(), "name")

		storageAccount, err := storageAccountClient.GetProperties(context.Background(), resourceGroupName, storageAccountName, nil)
		if err != nil {
			t.Fatalf("Error getting storage account: %v", err)
		}

		assert.Equal(t, getStorageAccountName(*storageAccount.Name), strings.Trim(getStorageAccountName(storageAccountName), "]"))
	})
}

func getStorageAccountName(input string) string {
	parts := strings.Split(input, "/")
	return parts[len(parts)-1]
}
