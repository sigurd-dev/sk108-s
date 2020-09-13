unit sk108sunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IDEWindowIntf, Forms, Controls, Graphics,
  Dialogs, StdCtrls, LCLType, Spin, IniPropStorage, Menus,
  strutils, process;

type

  { TFormSK108S }

  TFormSK108S = class(TForm)
    Button_info: TButton;
    Button_save: TButton;
    Button_default: TButton;
    Button_read: TButton;
    Button_load: TButton;
    Button_write: TButton;
    ComboBox_rfrate: TComboBox;
    ComboBox_serial: TComboBox;
    Edit_netid: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit10: TFloatSpinEdit;
    FloatSpinEdit11: TFloatSpinEdit;
    FloatSpinEdit12: TFloatSpinEdit;
    FloatSpinEdit13: TFloatSpinEdit;
    FloatSpinEdit14: TFloatSpinEdit;
    FloatSpinEdit15: TFloatSpinEdit;
    FloatSpinEdit16: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    FloatSpinEdit4: TFloatSpinEdit;
    FloatSpinEdit5: TFloatSpinEdit;
    FloatSpinEdit6: TFloatSpinEdit;
    FloatSpinEdit7: TFloatSpinEdit;
    FloatSpinEdit8: TFloatSpinEdit;
    FloatSpinEdit9: TFloatSpinEdit;
    GroupBox_channel: TGroupBox;
    GroupBox_time: TGroupBox;
    GroupBox_device: TGroupBox;
    GroupBox_rf: TGroupBox;
    IniPropStorage: TIniPropStorage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label_slow: TLabel;
    Label_InquiryTime: TLabel;
    Label_fast: TLabel;
    Label_netid: TLabel;
    Label_rfrate: TLabel;
    MainMenu: TMainMenu;
    MenuItem_About: TMenuItem;
    MenuItem_Exit: TMenuItem;
    MenuItem_file: TMenuItem;
    MenuItem_Help: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SpinEdit_slow: TSpinEdit;
    SpinEdit_InquiryTime: TSpinEdit;
    SpinEdit_fast: TSpinEdit;
    procedure Button_defaultClick(Sender: TObject);
    procedure Button_infoClick(Sender: TObject);
    procedure Button_loadClick(Sender: TObject);
    procedure Button_readClick(Sender: TObject);
    procedure Button_saveClick(Sender: TObject);
    procedure Button_writeClick(Sender: TObject);
    procedure Edit_netidEditingDone(Sender: TObject);
    procedure Edit_netidKeyPress(Sender: TObject; var Key: char);
    procedure MenuItem_AboutClick(Sender: TObject);
    procedure MenuItem_ExitClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSK108S: TFormSK108S;

implementation

{$R *.lfm}

{ TFormSK108S }

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.StrictDelimiter := true;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

procedure TFormSK108S.Edit_netidKeyPress(Sender: TObject; var Key: char);
begin
  if (Key in ['0'..'9', 'A'..'F', 'a'..'f',  Char(VK_BACK), Char(VK_DELETE)]) then
  else Key := #0;
end;

procedure TFormSK108S.MenuItem_AboutClick(Sender: TObject);
begin
  ShowMessage(ExtractFileNameOnly(Application.ExeName) +  ' - Program to read and write to SK108. - ' + sLineBreak +
  sLineBreak + 'Version 1.1.0 2018 ⓒ  Sigurd Dagestad.' + sLineBreak + sLineBreak +  'http://www.dagestad.info' + sLineBreak +
  sLineBreak +  'This is an alternative to NiceRF''s Windows only software.' +
  sLineBreak + sLineBreak + 'sigurd@dagestad.info');
end;

procedure TFormSK108S.Button_infoClick(Sender: TObject);
begin
  ShowMessage('How to read and write:' + sLineBreak + sLineBreak +
              '1. Set dip 5 to OFF on SKXXX.' + sLineBreak +
              '2. Recylce power on SKXXX.' + sLineBreak +
              '3. Read or Write data to SKXXX.' + sLineBreak +
              '4. Set dip 5 to ON on SKXXX.' + sLineBreak +
              '5. Recycle power on SKXXX.');

end;

procedure TFormSK108S.MenuItem_ExitClick(Sender: TObject);
begin
  Close();
end;

procedure TFormSK108S.Edit_netidEditingDone(Sender: TObject);
begin
   Edit_netid.Text:=UpperCase(Edit_netid.Text);
end;

procedure TFormSK108S.Button_defaultClick(Sender: TObject);
begin
  FloatSpinEdit1.Value:=428.325;
  FloatSpinEdit2.Value:=428.825;
  FloatSpinEdit3.Value:=429.325;
  FloatSpinEdit4.Value:=429.825;
  FloatSpinEdit5.Value:=430.325;
  FloatSpinEdit6.Value:=430.825;
  FloatSpinEdit7.Value:=431.325;
  FloatSpinEdit8.Value:=431.825;
  FloatSpinEdit9.Value:=432.325;
  FloatSpinEdit10.Value:=432.825;
  FloatSpinEdit11.Value:=433.325;
  FloatSpinEdit12.Value:=433.825;
  FloatSpinEdit13.Value:=434.325;
  FloatSpinEdit14.Value:=434.825;
  FloatSpinEdit15.Value:=435.325;
  FloatSpinEdit16.Value:=435.825;
  SpinEdit_InquiryTime.Value:=30;
  SpinEdit_fast.Value:=2;
  SpinEdit_slow.Value:=30;
  Edit_netid.Text:='00000000';
  ComboBox_rfrate.ItemIndex:=0;
  ComboBox_serial.Text:='/dev/ttyUSB0';
end;


procedure TFormSK108S.Button_readClick(Sender: TObject);
var

  s: AnsiString;
  hex: AnsiString;
  bytesread: Integer;
  A: TStringList;
  B: TStringList;
begin
  try
     RunCommand('/usr/bin/readsk108s',[ComboBox_serial.Text], s);
     //ShowMessage(s);
     A := TStringList.Create;

     split(':', s, A);
     bytesread:=StrToInt(A[1]);
     hex:=A[2];
     A.Free;
     if bytesread <> 60 then ShowMessage('Wrong number of bytes read, try again.');

     B := TStringList.Create;
     split(' ', hex, B);
     FloatSpinEdit1.Value:=Hex2Dec(B[2]+B[3]+B[4])/1000;
     FloatSpinEdit2.Value:=Hex2Dec(B[5]+B[6]+B[7])/1000;
     FloatSpinEdit3.Value:=Hex2Dec(B[8]+B[9]+B[10])/1000;
     FloatSpinEdit4.Value:=Hex2Dec(B[11]+B[12]+B[13])/1000;
     FloatSpinEdit5.Value:=Hex2Dec(B[14]+B[15]+B[16])/1000;
     FloatSpinEdit6.Value:=Hex2Dec(B[17]+B[18]+B[19])/1000;
     FloatSpinEdit7.Value:=Hex2Dec(B[20]+B[21]+B[22])/1000;
     FloatSpinEdit8.Value:=Hex2Dec(B[23]+B[24]+B[25])/1000;
     FloatSpinEdit9.Value:=Hex2Dec(B[26]+B[27]+B[28])/1000;
     FloatSpinEdit10.Value:=Hex2Dec(B[29]+B[30]+B[31])/1000;
     FloatSpinEdit11.Value:=Hex2Dec(B[32]+B[33]+B[34])/1000;
     FloatSpinEdit12.Value:=Hex2Dec(B[35]+B[36]+B[37])/1000;
     FloatSpinEdit13.Value:=Hex2Dec(B[38]+B[39]+B[40])/1000;
     FloatSpinEdit14.Value:=Hex2Dec(B[41]+B[42]+B[43])/1000;
     FloatSpinEdit15.Value:=Hex2Dec(B[44]+B[45]+B[46])/1000;
     FloatSpinEdit16.Value:=Hex2Dec(B[47]+B[48]+B[49])/1000;
     Edit_netid.Text:=B[50]+B[51]+B[52]+B[53];
     ComboBox_rfrate.ItemIndex:=Hex2Dec(B[54]);
     SpinEdit_InquiryTime.Value:=Hex2Dec(B[55]);
     SpinEdit_fast.Value:=Hex2Dec(B[56]);
     SpinEdit_slow.Value:=Hex2Dec(B[57]);

     //ShowMessage(FloatToStr(Hex2Dec(c1)/1000));

     B.Free;
  except
     On E :Exception do begin
       //ShowMessage(E.Message);
       ShowMessage('Make sure dip 5 is set to off on the SK radio, and that you have connected the SK108S to the computer. Also check the chosen device.');
     end;
  end;
end;

procedure TFormSK108S.Button_writeClick(Sender: TObject);
var
  cmd: String;
  tmp: String;
  s: String;
begin
  {cmd:='\x44\x52';
  //Memo.Lines.Add(IntToHex(428325,6));

  tmp:=IntToHex(round(FloatSpinEdit1.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit2.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit3.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit4.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit5.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit6.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit7.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit8.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit9.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit10.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit11.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit12.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit13.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit14.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit15.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit16.Value*1000),6);
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6];
  tmp:=Edit_netid.Text;
  cmd:=cmd+'\x'+tmp[1]+tmp[2]+'\x'+tmp[3]+tmp[4]+'\x'+tmp[5]+tmp[6]+'\x'+tmp[7]+tmp[8];
  tmp:=IntToStr(ComboBox_rfrate.ItemIndex);
  cmd:=cmd+'\x0'+tmp[1];
  tmp:=IntToHex(round(SpinEdit_InquiryTime.Value),2);
  cmd:=cmd+'\x'+tmp[1]+tmp[2];
  tmp:=IntToHex(round(SpinEdit_fast.Value),2);
  cmd:=cmd+'\x'+tmp[1]+tmp[2];
  tmp:=IntToHex(round(SpinEdit_slow.Value),2);
  cmd:=cmd+'\x'+tmp[1]+tmp[2];
  cmd:=cmd+'\x0D\x0A';  }

  cmd:='4452';
  //Memo.Lines.Add(IntToHex(428325,6));

  tmp:=IntToHex(round(FloatSpinEdit1.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit2.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit3.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit4.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit5.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit6.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit7.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit8.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit9.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit10.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit11.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit12.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit13.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit14.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit15.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=IntToHex(round(FloatSpinEdit16.Value*1000),6);
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6];
  tmp:=Edit_netid.Text;
  cmd:=cmd+tmp[1]+tmp[2]+tmp[3]+tmp[4]+tmp[5]+tmp[6]+tmp[7]+tmp[8];
  tmp:=IntToStr(ComboBox_rfrate.ItemIndex);
  cmd:=cmd+'0'+tmp[1];
  tmp:=IntToHex(round(SpinEdit_InquiryTime.Value),2);
  cmd:=cmd+tmp[1]+tmp[2];
  tmp:=IntToHex(round(SpinEdit_fast.Value),2);
  cmd:=cmd+tmp[1]+tmp[2];
  tmp:=IntToHex(round(SpinEdit_slow.Value),2);
  cmd:=cmd+tmp[1]+tmp[2];
  cmd:=cmd+'0D0A';

  //16	12:38:37.087	0.00374890	NiceRF.exe	IRP_MJ_WRITE                        	COM7	SUCCESS	Length: 60, Data: 44 52 06 89 25 06 8B 19 06 8D 0D 06 8F 01 06 90 F5 06 92 E9 06 94 DD 06 96 D1 06 98 C5 06 9A B9 06 9C AD 06 9E A1 06 A0 95 06 A2 89 06 A4 7D 06 A6 71 F0 00 00 01 00 1E 02 1E 0D 0A


  //ShowMessage(cmd);
  //ShowMessage(IntToHex(round(FloatSpinEdit1.Value*1000),6));
  try
    RunCommand('/usr/bin/writesk108s',[ComboBox_serial.Text, cmd], s);
    //ShowMessage(s);
    if Trim(s) = 'Read:6:44 52 4F 4B 0D 0A' then ShowMessage('Successful writing through SK108S.')
    else ShowMessage('Error writing through SK108S.' + #13#10 + 'Please try again.')
  except
     On E :Exception do begin
        //ShowMessage(E.Message);
        ShowMessage('Make sure dip 5 is set to off on the SK radio, and that you have connected the SK108S to the computer. Also check the chosen device.');
     end;
    end;

end;

//Se under Form.SessionProperties
procedure TFormSK108S.Button_saveClick(Sender: TObject);
begin
   SaveDialog.Execute;
   if SaveDialog.FileName <> '' then begin
      IniPropStorage.IniFileName:=SaveDialog.FileName;
      IniPropStorage.Save;
   end;
end;

procedure TFormSK108S.Button_loadClick(Sender: TObject);
begin
  OpenDialog.Execute;
  if OpenDialog.FileName <> '' then begin
     IniPropStorage.IniFileName:=OpenDialog.FileName;
     IniPropStorage.Restore;
  end;
end;


end.

