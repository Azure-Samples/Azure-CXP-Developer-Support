---
page_type: sample
languages:
- go
products:
- azure-storage	
---


# Go sample code uses the azfile sdk for go package to perform the file snapshot create and restore operation.

 Code Overview and Pre-requisites
 
 This sample code uses the azfile sdk for go package to restore and create the file snapshot in the Azure Storage account.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Please set environment variable ACCOUNT_NAME and ACCOUNT_KEY to your storage accout name and account key.
 Use go version go1.18.1 windows/amd64.  Package to be imported are listed in the sample code below.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

package main

import (
	"context"
	"fmt"
	"log"
	"net/url"
	"os"
	"time"

	"github.com/Azure/azure-storage-file-go/azfile"
)

// Please set environment variable ACCOUNT_NAME and ACCOUNT_KEY to your storage accout name and account key,
// before run the examples.
func accountInfo() (string, string) {
	return os.Getenv("ACCOUNT_NAME"), os.Getenv("ACCOUNT_KEY")
}

func main() {
	// From the Azure portal, get your Storage account file service URL endpoint.
	accountName, accountKey := accountInfo()
	credential, err := azfile.NewSharedKeyCredential(accountName, accountKey)
	if err != nil {
		log.Fatal(err)
	}

	ctx := context.Background() // This example uses a never-expiring context

	u, _ := url.Parse(fmt.Sprintf("https://%s.file.core.windows.net", accountName))
	serviceURL := azfile.NewServiceURL(*u, azfile.NewPipeline(credential, azfile.PipelineOptions{}))

	shareName := "baseshare"
	shareURL := serviceURL.NewShareURL(shareName)

	_, err = shareURL.Create(ctx, azfile.Metadata{}, 0)
	if err != nil {
		log.Fatal(err)
	}

	defer shareURL.Delete(ctx, azfile.DeleteSnapshotsOptionInclude)

	// Let's create a file in the base share.
	fileURL := shareURL.NewRootDirectoryURL().NewFileURL("myfile")
	_, err = fileURL.Create(ctx, 0, azfile.FileHTTPHeaders{}, azfile.Metadata{})
	if err != nil {
		log.Fatal(err)
	}

	// CREATE SHARE SNAPSHOT, the snapshot contains the created file.
	snapshotShare, err := shareURL.CreateSnapshot(ctx, azfile.Metadata{})
	fmt.Printf("Created share snapshot: %s", snapshotShare.Snapshot())

	// List share snapshots.
	listSnapshot, err := serviceURL.ListSharesSegment(ctx, azfile.Marker{}, azfile.ListSharesOptions{Detail: azfile.ListSharesDetail{Snapshots: true}})
	for _, share := range listSnapshot.ShareItems {
		if share.Snapshot != nil {
			fmt.Printf("Listed share snapshot: %s\n", *share.Snapshot)
		}
	}

	// Delete file in base share.
	_, err = fileURL.Delete(ctx)
	if err != nil {
		log.Fatal(err)
	}

	// RESTORE FILE FROM A SNAPSHOT
	
	// Create a SAS.
	sasQueryParams, err := azfile.FileSASSignatureValues{
		Protocol:   azfile.SASProtocolHTTPS,              // Users MUST use HTTPS (not HTTP)
		ExpiryTime: time.Now().UTC().Add(48 * time.Hour), // 48-hours before expiration
		ShareName:  shareName,

		// To produce a share SAS (as opposed to a file SAS), assign to Permissions using
		// ShareSASPermissions and make sure the DirectoryAndFilePath field is "" (the default).
		Permissions: azfile.ShareSASPermissions{Read: true, Write: true}.String(),
	}.NewSASQueryParameters(credential)
	if err != nil {
		log.Fatal(err)
	}

	// Build a file snapshot URL.
	fileParts := azfile.NewFileURLParts(fileURL.URL())
	fileParts.ShareSnapshot = snapshotShare.Snapshot()
	fileParts.SAS = sasQueryParams
	sourceURL := fileParts.URL()

	// Do restore.
	fileURL.StartCopy(ctx, sourceURL, azfile.Metadata{})
	if err != nil {
		log.Fatal(err)
	}

	// Delete share snapshot. To delete individual share snapshot, please use azfile.DeleteSnapshotsOptionNone
	_, err = shareURL.WithSnapshot(snapshotShare.Snapshot()).Delete(ctx, azfile.DeleteSnapshotsOptionNone)
	if err != nil {
		log.Fatal(err)
	}
}
```
