ARG ContainerUnderTest=appyway/worker-tools

FROM ${ContainerUnderTest}
SHELL ["powershell", "-Command"]