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


unit DDuce.Factories.zObjInspector;

interface

uses
  System.Classes,
  Vcl.Controls,

  zObjInspector, zValueManager;

type
  TzObjectInspectorFactory = class sealed
    class function Create(
      AOwner        : TComponent;
      AParent       : TWinControl;
      AObject       : TObject = nil;
      AValueManager : TzCustomValueManager = nil;
      const AName   : string = ''
    ): TzObjectInspector; static;

  end;

implementation

{ TzObjectInspectorFactory }

class function TzObjectInspectorFactory.Create(AOwner: TComponent;
  AParent: TWinControl; AObject: TObject; AValueManager: TzCustomValueManager;
  const AName: string): TzObjectInspector;
begin
end;

end.
