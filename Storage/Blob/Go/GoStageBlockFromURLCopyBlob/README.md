---
page_type: sample
languages:
- go
products:
- azure-storage	
---


# Go sample code uses the azblob sdk for go package to call StageBlockFromURL() to copy within the same account with SharedKeyCredential.

 Code Overview and Pre-requisites
 
 This sample code uses the azblob sdk for go package to call StageBlockFromURL() to copy within the same account with SharedKeyCredential.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Use go version go1.18.1 windows/amd64
 Package to be imported are listed in the sample code below.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

package main

import (
	"bytes"
	"context"

	"encoding/base64"
	"encoding/binary"
	"fmt"
	"log"
	"math/rand"
	"runtime"
	"strings"
	"time"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/streaming"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
)

func main() {

	// Use your storage account's name and key to create a credential object, used to access your account.
	// You can obtain these details from the Azure Portal.
	accountName := "navbastoragedemo"
	accountKey := "JF1bMEJ0IfVVp/BT48zUGD0+EKzz+ZTCKVFfcbFcn4GRhhzf2UTK8C5jfP04gatufB34WSVkC4vDugc0HXuzaw=="

	cred, err := azblob.NewSharedKeyCredential(accountName, accountKey)
	if err != nil {
		log.Fatalf("failed to obtain a key: %v", err)
	}

	// Open up a service client.
	// You'll need to specify a service URL, which for blob endpoints usually makes up the syntax http(s)://<account>.blob.core.windows.net/
	svcClient, err := azblob.NewServiceClientWithSharedKey(fmt.Sprintf("https://%s.blob.core.windows.net/", accountName), cred, nil)
	if err != nil {
		log.Fatalf("failed to obtain a serviceclient: %v", err)
	}

	containerName := "demonavba"
	containerClient, err := svcClient.NewContainerClient(containerName)
	testName := "blobname"
	contentSize := 8 * 1024 // 8 KB
	content := make([]byte, contentSize)
	body := bytes.NewReader(content)
	rsc := streaming.NopCloser(body)

	ctx := context.Background() // Use default Background context
	srcBlob, _ := containerClient.NewBlockBlobClient("src" + testName)

	destBlob, _ := containerClient.NewBlockBlobClient("test/" + "dst" + testName)

	// Prepare source bbClient for copy.
	uploadSrcResp, err := srcBlob.Upload(ctx, rsc, nil)

	fmt.Println("statuscode is:", uploadSrcResp.RawResponse.StatusCode)
	// Get source blob url with SAS for StageFromURL.
	srcBlobParts, _ := azblob.NewBlobURLParts(srcBlob.URL())

	//credential, err := getGenericCredential(nil, testAccountDefault)

	srcBlobParts.SAS, err = azblob.BlobSASSignatureValues{
		Protocol:      azblob.SASProtocolHTTPS,              // Users MUST use HTTPS (not HTTP)
		ExpiryTime:    time.Now().UTC().Add(48 * time.Hour), // 48-hours before expiration
		ContainerName: srcBlobParts.ContainerName,
		BlobName:      srcBlobParts.BlobName,
		Permissions:   azblob.BlobSASPermissions{Read: true}.String(),
	}.NewSASQueryParameters(cred)

	srcBlobURLWithSAS := srcBlobParts.URL()

	// Stage blocks from URL.
	blockIDs := generateBlockIDsList(2)

	stageResp1, err := destBlob.StageBlockFromURL(ctx, blockIDs[0], srcBlobURLWithSAS, 0, &azblob.BlockBlobStageBlockFromURLOptions{
		Offset: to.Ptr[int64](0),
		Count:  to.Ptr(int64(contentSize / 2)),
	})
	fmt.Println("Destination Blob status code:", stageResp1.RawResponse.StatusCode)

	stageResp2, err := destBlob.StageBlockFromURL(ctx, blockIDs[1], srcBlobURLWithSAS, 0, &azblob.BlockBlobStageBlockFromURLOptions{
		Offset: to.Ptr(int64(contentSize / 2)),
		Count:  to.Ptr(int64(4096)),
	})
	fmt.Println("Destination Blob is:", stageResp2.RawResponse.StatusCode)
	//	Check block list.
	blockList, err := destBlob.GetBlockList(context.Background(), azblob.BlockListTypeAll, nil)
	fmt.Println("Destination Blob status code:", blockList.RawResponse.StatusCode)
	// Commit block list.
	listResp, err := destBlob.CommitBlockList(context.Background(), blockIDs, nil)
	fmt.Println("Destination Blob is:", listResp.RawResponse.StatusCode)
}

func generateName(prefix string) string {
	// These next lines up through the for loop are obtaining and walking up the stack
	// trace to extrat the test name, which is stored in name
	pc := make([]uintptr, 10)
	runtime.Callers(0, pc)
	frames := runtime.CallersFrames(pc)
	name := ""
	for f, next := frames.Next(); next; f, next = frames.Next() {
		name = f.Function
		if strings.Contains(name, "Suite") {
			break
		}
	}
	funcNameStart := strings.Index(name, "Test")
	name = name[funcNameStart+len("Test"):] // Just get the name of the test and not any of the garbage at the beginning
	name = strings.ToLower(name)            // Ensure it is a valid resource name
	currentTime := time.Now()
	name = fmt.Sprintf("%s%s%d%d%d", prefix, strings.ToLower(name), currentTime.Minute(), currentTime.Second(), currentTime.Nanosecond())
	return name
}

func getRandomDataAndReader(n int) (*bytes.Reader, []byte) {
	data := make([]byte, n, n)
	rand.Read(data)
	return bytes.NewReader(data), data
}
func getReaderToRandomBytes(n int) *bytes.Reader {
	r, _ := getRandomDataAndReader(n)
	return r
}

func generateBlockIDsList(count int) []string {
	blockIDs := make([]string, count)
	for i := 0; i < count; i++ {
		blockIDs[i] = blockIDIntToBase64(i)
	}
	return blockIDs
}

func blockIDIntToBase64(blockID int) string {
	binaryBlockID := (&[4]byte{})[:]
	binary.LittleEndian.PutUint32(binaryBlockID, uint32(blockID))
	return base64.StdEncoding.EncodeToString(binaryBlockID)
}
```
