#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\anderson\Google ����\development\autoit\projects\011_file_generator\gui.kxf
$Form1 = GUICreate("FileGenerator", 421, 264, 602, 279)
$Input1 = GUICtrlCreateInput("���� �� �����", 112, 10, 300, 21)
$Button1 = GUICtrlCreateButton("������� �����", 8, 8, 100, 25)
$Group1 = GUICtrlCreateGroup("��� ���������?", 8, 40, 194, 105)
$Radio1 = GUICtrlCreateRadio("���������� ������� (random)", 16, 64, 175, 17)
$Radio2 = GUICtrlCreateRadio("��������� (111...)", 16, 88, 175, 17)
$Radio3 = GUICtrlCreateRadio("������ (000...)", 16, 112, 175, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Input2 = GUICtrlCreateInput("�� 1 �� 100", 208, 64, 202, 21)
$Label1 = GUICtrlCreateLabel("���������� ������:", 208, 40, 202, 17)
$Label2 = GUICtrlCreateLabel("����� ����� (� ����������)", 208, 96, 204, 17)
$Input3 = GUICtrlCreateInput("�� 1 �� �� 50 ��", 208, 120, 202, 21)
$Button2 = GUICtrlCreateButton("�������������", 8, 152, 402, 100)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $tPath, $nNumberOfFiles, $nVolume

; ����� ��������� ��������
$tPath          = ""
$nNumberOfFiles = 0
$nVolume        = 0
GUICtrlSetState ( $Radio2, $GUI_CHECKED )

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
   Case $GUI_EVENT_CLOSE
	  Exit

   Case $Button1
	  $tPath = FileSelectFolder ( "������� �����", @ScriptDir ) ; �������� �����, ��� ����� �������������� �����
	  GUICtrlSetData ( $Input1, $tPath )
	  ; ConsoleWrite( @ScriptLineNumber & " " & $tPath & @CRLF )

   Case $Button2
	  ; ConsoleWrite( @ScriptLineNumber & " " & $tPath & @CRLF )
	  If $tPath <> "" Then
		 $hTimer = TimerInit()
		 _FileGenerate($tPath)
		 $fDiff = Round (TimerDiff($hTimer) / 1000, 2)
		 MsgBox(0,"������","�� ��������� ���� " & $fDiff & " ������")
	  Else
		 MsgBox(0,"�������� �����","����� ���������� ���������� ������� �����")
	  EndIf

   EndSwitch
WEnd

Func _FileGenerate($tPath)
   Local $g, $nFile
   ; �������� ����� ������ ������
   $fRadio1 = GUICtrlRead( $Radio1 )
   $fRadio2 = GUICtrlRead( $Radio2 )
   $fRadio3 = GUICtrlRead( $Radio3 )

   ; ��������� Input'�
   $nNumberOfFiles = _GetNumber()
   $nVolume        = _GetVolume()

   ; ���������� ����� ���� �����
   $nVolumeOfOne = Round ( ($nVolume / $nNumberOfFiles), 0)
   ConsoleWrite( @ScriptLineNumber & " " & $nVolumeOfOne & @CRLF )

   ; ���������� ����� ������ �����
   $nVolumeOfFile = $nVolumeOfOne * 1024 * 1024

   ; ���������� ���������
   $g     = 0 ; ������� ������
   $t     = 0 ; ������� ��������
   $nFile = ""
   While $g <> $nNumberOfFiles
   $nFile = FileOpen ( $tPath & "\" & _RandomText(8) & ".txt" , 2)
	  Select
	  Case $fRadio1 = 1 ; ���� ��������� �����
		 While $t < $nVolumeOfFile
			FileWrite( $nFile, _RandomText(1) )
			$t = $t + 1
		 WEnd

	  Case $fRadio2 = 1 ; ���� ��������
		 While $t < $nVolumeOfFile
			FileWrite( $nFile, 1 )
			$t = $t + 1
		 WEnd

	  Case $fRadio3 = 1 ; ���� ����
		 While $t < $nVolumeOfFile
			FileWrite( $nFile, 0 )
			$t = $t + 1
		 WEnd

	  EndSelect
   FileClose( $nFile )
   $nFile = ""
   $t = 0
   $g = $g + 1
   WEnd
EndFunc

Func _GetNumber()
   Local $t1, $t2
   $t1 = GUICtrlRead ( $Input2 )
   If StringIsInt ( $t1 ) and $t1 > 1 and $t1 < 100 Then
	  $t2 = $t1
   Else
	  MsgBox(0,"�������","������� ����� ����� �� 1 �� 100")
   EndIf
   Return $t2
EndFunc

Func _GetVolume()
   Local $t1, $t2
   $t1 = GUICtrlRead ( $Input3 )
   If StringIsInt ( $t1 ) and $t1 > 1 and $t1 < 51201 Then
	  $t2 = $t1
   Else
	  MsgBox(0,"�������","������� ����� ����� �� 1 �� 51200")
   EndIf
   Return $t2
EndFunc

Func _RandomText($length) ; �������� �������� ��������������� �����
    $text = ""
    For $i = 1 To $length
        $temp = Random(65, 122, 1)
        While $temp >= 90 And $temp <= 96
            $temp = Random(65, 122, 1)
        WEnd
        $temp = Chr($temp)
        $text &= $temp
    Next
    Return $text
EndFunc   ;==>_RandomText