resource "aws_s3_bucket" "files" {
  bucket_prefix = "etcd3-files"
  acl           = "private"
}

resource "aws_s3_bucket_object" "etcd3-bootstrap-linux-amd64" {
  bucket       = "${aws_s3_bucket.files.id}"
  key          = "etcd3-bootstrap-linux-amd64"
  source       = "files/etcd3-bootstrap-linux-amd64"
  etag         = "${md5(file("files/etcd3-bootstrap-linux-amd64"))}"
  acl          = "public-read"
  content_type = "application/octet-stream"
}
