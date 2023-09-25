FROM ubuntu:18.04

# Install wget
RUN apt-get update
RUN apt-get install -y wget

# Add 32-bit architecture
RUN dpkg --add-architecture i386
RUN apt-get update

# Install Wine
RUN apt-get install -y software-properties-common gnupg2
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
RUN apt-get install -y --install-recommends winehq-stable winbind

# Turn off Fixme warnings
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEPREFIX=/root/.net 
ENV WINEARCH=win64
RUN winecfg

# Install Winetricks
RUN apt-get install -y cabextract
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks
RUN cp winetricks /usr/local/bin

# Install .NET Framework 4.5.2
RUN wineboot -u && winetricks -q dotnet452

# Compile HelloWorld.cs
COPY HelloWorld.cs /root/.net/drive_c/HelloWorld.cs
WORKDIR /root/.net/drive_c/
RUN wine /root/.net/drive_c/windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe HelloWorld.cs

# Run HelloWorld.exe
ENTRYPOINT ["wine", "HelloWorld.exe"]
