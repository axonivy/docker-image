FROM mcr.microsoft.com/windows/nanoserver:1809

RUN mkdir c:\XIVY
RUN curl https://download.axonivy.com/8.0.1/AxonIvyEngine8.0.1.1912241208_Windows_x64.zip --output c:\XIVY\engine.zip
RUN mkdir c:\XIVY\engine
RUN tar -xf c:\XIVY\engine.zip -C c:\XIVY\engine

ENTRYPOINT c:\XIVY\engine\bin\AxonIvyEngineC.exe
