sudo port install openjdk8
## Java development
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk8/Contents/Home"
curl https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz --output apache-maven-3.8.1.tar.gz
tar -xzf apache-maven-3.8.1.tar.gz 
mv apache-maven-3.8.1 /usr/local
echo -e "# add path for maven\nexport PATH=\"/usr/local/apache-maven-3.8.1/bin/:\$PATH\"" >> $ZDOTDIR/.zshrc
