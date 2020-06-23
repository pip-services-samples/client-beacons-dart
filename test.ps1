try {
    # Workaround to remove dangling images
    docker-compose -f ./docker/docker-compose.dev.yml down

    docker-compose -f ./docker/docker-compose.dev.yml up -d

    Start-Sleep -Seconds 15
  
    pub run test

    Write-Host "The HTTPClient was successfully tested."
    
    # Save the result to avoid overwriting it with the "down" command below
    $exitCode = $LastExitCode 
} finally {
    docker-compose -f ./docker/docker-compose.dev.yml down
}

# Return the exit code of the "docker-compose.dev.yml up" command
exit $exitCode 
