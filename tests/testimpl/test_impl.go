package common

import (
	"context"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/nexient-llc/lcaf-component-terratest-common/lib/azure/configure"
	"github.com/nexient-llc/lcaf-component-terratest-common/lib/azure/login"
	"github.com/nexient-llc/lcaf-component-terratest-common/lib/azure/network"
	"github.com/nexient-llc/lcaf-component-terratest-common/types"
	"github.com/stretchr/testify/assert"
	armStorage "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage"
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
	// Create network security group client
	storageAccountClient, err := armStorage.NewAccountsClient(subscriptionID, credential, options)
	if err != nil {
		t.Fatalf("Error getting Storage Account client: %v", err)
	}

	t.Run("doesStorageAccountExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		storageAccountName := terraform.Output(t, terraformOptions, "name")
		//id := terraform.Output(t, terraformOptions, "id")

		storageAccount, err := storageAccountClient.Get(context.Background(), resourceGroupName, storageAccountName, nil)
		if err != nil {
			t.Fatalf("Error getting storage account: %v", err)
		}
		fmt.Println(storageAccount.ID)
		// if nsg.Name == nil {
		// 	t.Fatalf("NSG does not exist")
		// }

		// assert.Equal(t, getNsgName(*nsg.ID), strings.Trim(getNsgName(nsgId), "]"))
		// assert.NotEmpty(t, *nsg.SecurityRules)
	})
}

// func getNsgName(input string) string {
// 	parts := strings.Split(input, "/")
// 	return parts[len(parts)-1]
// }
