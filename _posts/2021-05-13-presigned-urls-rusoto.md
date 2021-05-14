---
layout: post
title: "Generating pre-signed S3 URLs in Rust"
tags:
- rust
- aws
---

Creating Pre-signed S3 URLs in Rust took me a little more brainpower than I had
anticipated, so I thought I would share how to generate them using
[Rusoto](https://rusoto.github.io/).  [Pre-signed
URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ShareObjectPreSignedURL.html)
allow the creation of purpose built URLs for fetching or uploading objects to
S3, and can be especially useful when granting access to S3 objects to mobile
or web clients. In my use-case, I wanted the clients of my web service to be able to access some specific objects from a bucket.

Rusoto supports the creation of pre-signed URLs via the [PreSignedRequest](https://docs.rs/rusoto_s3/0.46.0/rusoto_s3/util/trait.PreSignedRequest.html) which is implemented for `GetObjectRequest`, `PutObjectRequest`, etc. The trait exposes a simple method `get_presigned_url` which returns a String with all the query parameters to allow for a pre-signed request. _Unfortunately_ however, these `GetObjectRequest` structs don't really blend easily with an existing [S3Client](https://docs.rs/rusoto_s3/0.46.0/rusoto_s3/struct.S3Client.html) and need to be constructed with the appropriate region and credentials whenever you want to use them.

Starting with the region, I re-use some code we have in [delta-rs](https://github.com/delta-io/delta-rs) for identifying the region in a way that allows testing with localstack or minio via the `AWS_ENDPOINT_URL` environment variable:


```rust
use rusoto_core::Region;

let region = if let Ok(url) = std::env::var("AWS_ENDPOINT_URL") {
    Region::Custom {
        name: std::env::var("AWS_REGION").unwrap_or_else(|_| "custom".to_string()),
        endpoint: url,
    }
} else {
    Region::default()
};
```

For most users, this code doesn't really do much, but if you've got a custom `AWS_REGION` or `AWS_ENDPOINT_URL`, you need to properly construct a custom `Region` in order for Rusoto to work.

The next important argument that `get_presigned_url` requires is an `AwsCredentials` provider, which I was originally quite worried about hacking into place. Once again I went looking at the delta-rs codebase for inspiration and noticed our use of `ChainProvider` which tries its best to find the right AWS credentials given the user's environment:

```rust
use rusoto_credential::ChainProvider;
use rusoto_credential::ProvideAwsCredentials;

let provider = ChainProvider::new();
let credentials = provider.credentials().await?;
```

With those two pieces in place, I could finally construct the URL!


```rust
use rusoto_s3::GetObjectRequest;
use rusoto_s3::util::{PreSignedRequest, PreSignedRequestOption};

let options = PreSignedRequestOption {
    expires_in: std::time::Duration::from_secs(300),
};
let req = GetObjectRequest {
    bucket: "my-bucket".to_string(),
    key: "secret.txt".to_string(),
    ..Default::default()
};
let url = req.get_presigned_url(&region, &credentials, &options);
```


Of course, in your application you might find the structure of managing a shared credentials provider or region to change the structure of the code. However you manage them, as long as you can plug a reference to either into the `get_presigned_url` function, you can generate useful pre-signed URLs for S3, [Minio](https://min.io), etc.
