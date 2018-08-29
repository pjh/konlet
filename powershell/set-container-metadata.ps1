# TODO: describe...

$metadataURL = "http://metadata.google.internal/computeMetadata/v1/instance"
# TODO: get instance name programatically from internal metadata server.
# TODO: getting 401 unauthorized for gets from this URL, bah.
#$metadataURL = "https://www.googleapis.com/compute/v1/projects/<PROJECT>/zones/us-west1-c/instances/konnn-dev-3"
$konnnKey = "attributes/gce-container-declaration"

try {
    $response = Invoke-RestMethod -Uri "$metadataURL/$konnnKey" -Method Get `
        -Headers @{"Metadata-Flavor"="Google"}
    $response
} catch {
    # The error ($_) is a System.Management.Automation.ErrorRecord; its
    # exception type is a System.Net.WebException.
    $statusCode = $_.Exception.Response.StatusCode.value__
    $statusDescription = $_.Exception.Response.StatusDescription
    echo "$statusCode : $statusDescription"
    # TODO: if the instance doesn't have the value, try the project?
    exit 1
}
exit 0


# This is a Hashtable System.Object.
$containerDeclaration = @{
    key='value'
    key2='value2'
}
$json = $containerDeclaration | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$metadataURL/$konnnKey" -Method Put `
        -Headers @{"Metadata-Flavor"="Google"} -Body $json `
        -ContentType 'application/json'
    $response
    exit
} catch {
    # The error ($_) is a System.Management.Automation.ErrorRecord; its
    # exception type is a System.Net.WebException.
    $statusCode = $_.Exception.Response.StatusCode.value__
    $statusDescription = $_.Exception.Response.StatusDescription
    echo "$statusCode : $statusDescription"
    # TODO: if the instance doesn't have the value, try the project?
    echo "No metadata present - not running containers"
    exit 1
}

#$response

# TODO: pull containerDeclaration out of $response...
$containerDeclaration = $response
$containerDeclaration = 'spec:
  containers:
  - name: busybox
    image: gcr.io/google-containers/busybox
    args:
    - sleep
    - "1000000"'
echo "Retrieved container declaration:`n$containerDeclaration`n"

# TODO: figure out how to pass $containerDeclaration into konlet container.
#   konlet startup scripts apparently just do this via $SPEC env var.
# TODO: figure out if/how to use these args:
#   --privileged
#     "invalid --privileged: Windows does not support this feature."
#   -v=/var/run/docker.sock:/var/run/docker.sock `
#   -v=/etc/profile.d:/host/etc/profile.d `
docker run --rm --log-driver=gcplogs --net="host" `
  gcr.io/gce-containers/konlet:v.alpha.0.7-latest
$docker_rc = $LASTEXITCODE

exit $docker_rc
