# TODO: describe...

$metadataURL = "http://metadata.google.internal/computeMetadata/v1/instance"
$konnnKey = "attributes/gce-container-declaration"

# TODO: add retries here, e.g. while "failed to resolve host" or "failed to
# connect to host."
try {
    # Invoke-RestMethod converts the returned JSON content string into a
    # PSObject.
    $response = Invoke-RestMethod -Uri "$metadataURL/$konnnKey" -Method Get `
        -Headers @{"Metadata-Flavor"="Google"}
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

# On success the response is a Powershell String containing the container
# declaration
$containerDeclaration = $response
echo "Retrieved container declaration:`n$containerDeclaration`n"

# TODO: figure out how to pass $containerDeclaration into konlet container.
#   konlet startup scripts apparently just do this via $SPEC env var.
# TODO: wrap this in a try-catch for prettier error printing?
# TODO: figure out if/how to use these args:
#   --privileged
#     "invalid --privileged: Windows does not support this feature."
#   -v=/var/run/docker.sock:/var/run/docker.sock `
#   -v=/etc/profile.d:/host/etc/profile.d `
#   --log-driver=gcplogs `
#   --net="host" `
# TODO: should this container be run in the background?
docker run --rm `
  gcr.io/<PROJECT>/gce-containers-startup:latest
  #gcr.io/gce-containers/konlet:v.alpha.0.7-latest
$docker_rc = $LASTEXITCODE

exit $docker_rc
