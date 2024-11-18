package mig_regional_lb

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	test "github.com/terraform-google-modules/terraform-google-lb-http/test/integration"
)

func TestMigRegionalLb(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		externalIp := bpt.GetStringOutput("external_ip")
		test.AssertResponseStatus(t, assert, "http://"+externalIp, 200)
	})

	bpt.Test()
}
