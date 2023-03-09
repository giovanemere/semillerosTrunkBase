# Copy the image
    docker pull doctorkirk/oracle-19c

# Create local directory
    mkdir -p /your/custom/path/oracle-19c/oradata
    cd /your/custom/path/
    sudo chown -R 54321:54321 oracle-19c/

# Run the Container
    docker run --name oracle-19c \
    -p 1521:1521 \
    -e ORACLE_SID=[ORACLE_SID] \
    -e ORACLE_PWD=[ORACLE_PASSWORD] \
    -e ORACLE_CHARACTERSET=[CHARSET] \
    -v /your/custom/path/oracle-19c/oradata/:/opt/oracle/oradata \
    doctorkirk/oracle-19c