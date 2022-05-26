ARG ContainerUnderTest=appyway/worker-tools

FROM ${ContainerUnderTest}
SHELL ["pwsh", "-Command"]