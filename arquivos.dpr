program arquivos;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  Horse,
  Horse.Logger,
  Horse.OctetStream;

var
  App: THorse;
  HorseLoggerConfig : THorseLoggerConfig;

begin
  App := THorse.Create(9000);

  HorseLoggerConfig := THorseLoggerConfig.Create('${time} - ${request_method} ${request_path_info}');

  App.Use(OctetStream);
  App.Use(THorseLogger.New(HorseLoggerConfig));

  try

    App.Get('arquivos',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        LStream: TFileStream;
      begin
        LStream := TFileStream.Create('C:\Users\wande\Pictures\Imagens Diversas\games\batman_001.png', fmOpenRead);
        Res.Send<TStream>(LStream);
      end);

    App.Post('arquivos',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        LStream: TMemoryStream;
      begin
        LStream := Req.Body<TMemoryStream>;
        LStream.SaveToFile('C:\Users\wande\Pictures\Imagens Diversas\games\CopiaBatman.png');
        Res.Send('Imagem salva com sucesso!').Status(201);
      end);

    App.Start;

  finally
    App.Free;
  end;

end.
