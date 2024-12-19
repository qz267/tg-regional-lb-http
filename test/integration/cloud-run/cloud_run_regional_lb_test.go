// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cloud_run_regional_lb

import (
	"testing"

	"io"
	"net/http"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func AssertResponseStatus(t *testing.T, assert *assert.Assertions, url string, statusCode int) {
	var resStatusCode int
	resStatusCode, _, _ = httpGetRequest(t, url, 60*time.Second)
	assert.Equal(statusCode, resStatusCode)
}

func httpGetRequest(t *testing.T, url string, timeout time.Duration) (statusCode int, body string, err error) {
	t.Helper()

	// Create an HTTP client with a timeout
	client := &http.Client{
		Timeout: timeout,
	}

	// Perform the GET request
	res, err := client.Get(url)
	if err != nil {
		t.Fatalf("http get unexpected err: %v", err)
		return 0, "", err // Return here to satisfy the function signature
	}
	defer res.Body.Close()

	// Read the response body
	buffer, err := io.ReadAll(res.Body)
	if err != nil {
		t.Fatalf("reading response body unexpected err: %v", err)
		return 0, "", err // Return here to satisfy the function signature
	}

	return res.StatusCode, string(buffer), nil
}

func TestCloudRunRegionalLb(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		externalIp := bpt.GetStringOutput("external_ip")
		AssertResponseStatus(t, assert, "http://"+externalIp, 200)
	})

	bpt.Test()
}
