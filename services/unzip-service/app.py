import zipfile
import boto3

s3 = boto3.client("s3")

def unzip_and_upload(zip_file, asin):
    """
    Extracts files and uploads to S3.

    S3 path:
    s3://shazam-assets/{asin}/
    """

    with zipfile.ZipFile(zip_file) as z:
        for file in z.namelist():
            s3.upload_fileobj(
                z.open(file),
                "shazam-assets",
                f"{asin}/{file}"
            )
