// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package test

import (
	"testing"

	"github.com/nexient-llc/lcaf-component-terratest-common/lib"
	"github.com/nexient-llc/lcaf-component-terratest-common/types"
	testimpl "github.com/nexient-llc/tf-azurerm-module_primitive-storage_account/tests/testimpl"
)

const (
	testConfigsExamplesFolderDefault = "../../examples/storage_account"
	infraTFVarFileNameDefault        = "test.tfvars"
)

func TestStorageAccountModule(t *testing.T) {

	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderDefault).
		SetTestConfigFileName(infraTFVarFileNameDefault).
		SetTestSpecificFlags(map[string]types.TestFlags{
			"complete": {
				"IS_TERRAFORM_IDEMPOTENT_APPLY": true,
			},
		}).
		Build()

	lib.RunNonDestructiveTest(t, *ctx, testimpl.TestStorageAccount)
}
