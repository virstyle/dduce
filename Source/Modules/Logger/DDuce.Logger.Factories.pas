{
  Copyright (C) 2013-2017 Tim Sinaeve tim.sinaeve@gmail.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit DDuce.Logger.Factories;

//{$I DDuce.inc}

interface

uses
  DDuce.Logger.Interfaces;

type
  TLoggerFactories = class sealed
    class function CreateLogger: ILogger;
    class function CreateWinIPCChannel: ILogChannel;
    class function CreateZeroMQChannel: ILogChannel;

  end;

implementation

uses
  DDuce.Logger.Base, DDuce.Logger.Channels.WinIPC,
  DDuce.Logger.Channels.ZeroMQ;

class function TLoggerFactories.CreateLogger: ILogger;
begin
  Result := TLogger.Create;
end;

class function TLoggerFactories.CreateWinIPCChannel: ILogChannel;
begin
  Result := TWinIPCChannel.Create;
end;

class function TLoggerFactories.CreateZeroMQChannel: ILogChannel;
begin
  Result := TZeroMQChannel.Create;
end;

end.
