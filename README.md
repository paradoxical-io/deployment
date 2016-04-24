# Paradoxical deployments
Deployment submodule for paradoxical repos

# Setting up a repo
Add a `.deployment` folder as a submodule refering to this repo
```
git submodule add -b master https://github.com/paradoxical-io/deployment.git .deployment
```

# Configure your `.travis.yml`
Add the following to your travis configuration
```
git:
  submodules: false
before_install:
  # https://git-scm.com/docs/git-submodule#_options:
  # --remote
  # Instead of using the superproject’s recorded SHA-1 to update the submodule,
  # use the status of the submodule’s remote-tracking (branch.<name>.remote) branch (submodule.<name>.branch).
  # --recursive
  # https://github.com/travis-ci/travis-ci/issues/4099
  - git submodule update --init --remote --recursive
after_success:
- ./.deployment/deploy.sh
```

# Run `setup-travs.sh`
Travis needs to be setup with all the secure variables we use for deployment

```
GPG_PASSWORD='<PASSWORD>' \
SONATYPE_USER='paradoxicalio' \
SONATYPE_PASSWORD='<PASSWORD>' \
GPG_PRIVATE_KEY_ENCRYPTION_KEY=<KEY> \
GPG_PRIVATE_KEY_ENCRYPTION_IV=<IV> \
./.deployment/setup-travis.sh
```

# Configure your `pom.xml`

## Setup the `version`
```
    <version>1.0${revision}</version>
```

## Add a `revision` property default
```
    <revision>-SNAPSHOT</revision>
```

## Ensure you have the repository defined
```
    <distributionManagement>
        <snapshotRepository>
            <id>ossrh</id>
            <url>https://oss.sonatype.org/content/repositories/snapshots</url>
        </snapshotRepository>
        <repository>
            <id>ossrh</id>
            <url>https://oss.sonatype.org/service/local/staging/deploy/maven2</url>
        </repository>
    </distributionManagement>
```

## Ensure you have the nexus plugin configured
```
    <plugin>
        <groupId>org.sonatype.plugins</groupId>
        <artifactId>nexus-staging-maven-plugin</artifactId>
        <version>1.6.6</version>
        <extensions>true</extensions>
        <configuration>
            <serverId>ossrh</serverId>
            <nexusUrl>https://oss.sonatype.org/</nexusUrl>
            <autoReleaseAfterClose>true</autoReleaseAfterClose>
        </configuration>
    </plugin>
```

## Add a `release` profile
```
    <profiles>
        <profile>
            <id>release</id>
            <build>
                <plugins>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-javadoc-plugin</artifactId>
                        <version>2.9.1</version>
                        <executions>
                            <execution>
                                <id>attach-javadocs</id>
                                <goals>
                                    <goal>jar</goal>
                                </goals>
                            </execution>
                        </executions>
                        <configuration>
                            <failOnError>false</failOnError>
                        </configuration>
                    </plugin>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-source-plugin</artifactId>
                        <version>${maven.source.plugin.version}</version>
                        <executions>
                            <execution>
                                <id>attach-sources</id>
                                <goals>
                                    <goal>jar-no-fork</goal>
                                </goals>
                            </execution>
                        </executions>
                    </plugin>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-gpg-plugin</artifactId>
                        <version>1.6</version>
                        <executions>
                            <execution>
                                <id>sign-artifacts</id>
                                <phase>verify</phase>
                                <goals>
                                    <goal>sign</goal>
                                </goals>
                            </execution>
                        </executions>
                        <configuration>
                            <defaultKeyring>false</defaultKeyring>
                            <keyname>476C78DF</keyname>
                            <passphrase>${env.GPG_PASSWORD}</passphrase>
                            <publicKeyring>${project.basedir}/.deployment/gpg/paradoxical-io.pubgpg</publicKeyring>
                            <secretKeyring>${project.basedir}/.deployment/gpg/paradoxical-io-private.gpg</secretKeyring>
                        </configuration>
                    </plugin>
                </plugins>
            </build>
        </profile>
    </profiles>
```

# Enabling maven caching
If you're adding this to a library then be sure to enable maven caching to improve build speeds
```
sudo: false
cache:
  directories:
  - $HOME/.m2
```

# More guidance
- [Someone elses settings](https://gist.github.com/m3t/df29ec4e0aae167f99c8)
- [Helpful Stackoverflow](http://stackoverflow.com/questions/9189575/git-submodule-tracking-latest/9189815#9189815)
- [Another SO](http://stackoverflow.com/questions/1777854/git-submodules-specify-a-branch-tag/18799234#18799234)
- [Submodules (docs)](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
