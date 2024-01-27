#Requires AutoHotkey v2.0.2
#SingleInstance
#Include "_jxon.ahk"
Persistent

/*
====================================================
脚本托盘菜单
====================================================
*/

TraySetIcon("Icon.ico")
A_TrayMenu.Delete
A_TrayMenu.Add("&Debug", Debug)
A_TrayMenu.Add("&Reload Script", ReloadScript)
A_TrayMenu.Add("E&xit", Exit)
A_IconTip := "ChatGPT AutoHotkey Utility"

ReloadScript(*) {
    Reload
}

Debug(*) {
    ListLines
}

Exit(*) {
    ExitApp
}

/*
====================================================
黑暗模式菜单
====================================================
*/

Class DarkMode {
    Static __New(Mode := 1) => ( ; Mode: Dark = 1, Default (Light) = 0
    DllCall(DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "uxtheme", "ptr"), "ptr", 135, "ptr"), "int", mode),
    DllCall(DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "uxtheme", "ptr"), "ptr", 136, "ptr"))
    )
}

/*
====================================================
变量
====================================================
*/

API_Key := "sk-0k0fbHJ3U39Zazf1lzxf65n7B3ss0W6J7FXgwEvKgCbM3k9Z"
API_URL := "https://api.openai.com/v1/chat/completions"
Status_Message := ""
Response_Window_Status := "Closed"
Retry_Status := ""

/*
====================================================
菜单和ChatGPT提示词
====================================================
*/

MenuPopup := Menu()
MenuPopup.Add("&1 - 改写", 改写)
MenuPopup.Add("&2 - 总结", 总结)
MenuPopup.Add("&3 - 解释", 解释)
MenuPopup.Add("&4 - 详述", 详述)
MenuPopup.Add()
MenuPopup.Add("&5 - 生成回复", 生成回复)
MenuPopup.Add("&6 - 查找行动项", 查找行动项)
MenuPopup.Add("&7 - 翻译为中文", 翻译为中文)

改写(*) {
    ChatGPT_Prompt := "对以下文本或段落进行改写，确保内容清晰、简洁并具有自然的语境连贯性。改写过程中应保留原文的语气、风格和格式，并在此基础上纠正遇到的所有语法和拼写错误："
    Status_Message := "正在进行改写..." 
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

总结(*) {
    ChatGPT_Prompt := "总结以下内容:"
    Status_Message := "正在进行总结..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

解释(*) {
    ChatGPT_Prompt := "解释以下内容:"
    Status_Message := "正在进行解释..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

详述(*) {
    ChatGPT_Prompt := "考虑到原文的语气、风格和格式，请帮助我以更清晰且表达力更强的方式来阐述以下观点。消息的风格可以根据原文上下文而变化，可以是正式、非正式、随意、富有同情心、坚定或有说服力的。为了便于阅读，文本应分为段落。无需刻意避免特定的语言复杂性，并且信息的重点应在整条消息中均匀分布。没有固定的最小或最大长度限制。下面是我想要表达的内容：" 
    Status_Message := "正在详述..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

生成回复(*) {
    ChatGPT_Prompt := "针对任意给定的消息创建一个回复。回复应当遵循原始发送者的语气、风格、格式以及文化或地区背景。保持与原始消息相同的正式程度和情感基调。只要能有效地向原始发送者传达回应，回复的长度可任意。"
    Status_Message := "生成回复中..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

查找行动项(*) {
    ChatGPT_Prompt := "找出需要完成的行动项，并以列表形式呈现："
    Status_Message := "正在查找行动项..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

翻译为中文(*) {
    ChatGPT_Prompt := "为以下文本或段落生成中文翻译，确保翻译准确传达原文的意图和意义，且无过多偏离。翻译应保持原文的语气、风格及格式。请不要给出除翻译结果外的任何内容：" 
    Status_Message := "翻译中..."
    API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}

/*
====================================================
创建响应窗口
====================================================
*/

Response_Window := Gui("-Caption", "Response")
Response_Window.BackColor := "0x333333"
Response_Window.SetFont("s13 cWhite", "Georgia")
Response := Response_Window.Add("Edit", "r20 ReadOnly w600 Wrap Background333333", Status_Message)
RetryButton := Response_Window.Add("Button", "x190 Disabled", "重试")
RetryButton.OnEvent("Click", Retry)
CopyButton := Response_Window.Add("Button", "x+30 w80 Disabled", "复制")
CopyButton.OnEvent("Click", Copy)
Response_Window.Add("Button", "x+30", "关闭").OnEvent("Click", Close)

/*
====================================================
按钮
====================================================
*/

Retry(*) {
    Retry_Status := "Retry"
    RetryButton.Enabled := 0
    CopyButton.Enabled := 0
    CopyButton.Text := "复制"
    ProcessRequest(Previous_ChatGPT_Prompt, Previous_Status_Message, Previous_API_Model, Retry_Status)
}

Copy(*) {
    A_Clipboard := Response.Value
    CopyButton.Enabled := 0
    CopyButton.Text := "已复制!"

    DllCall("SetFocus", "Ptr", 0)
    Sleep 2000

    CopyButton.Enabled := 1
    CopyButton.Text := "复制"
}

Close(*) {
    HTTP_Request.Abort
    Response_Window.Hide
    global Response_Window_Status := "Closed"
}

/*
====================================================
连接到ChatGPT API并处理请求
====================================================
*/

ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status) {
    if (Retry_Status != "Retry") {
        A_Clipboard := ""
        Send "^c"
        if !ClipWait(2) {
            MsgBox "The attempt to copy text onto the clipboard failed."
            return
        }
        CopiedText := A_Clipboard
        ChatGPT_Prompt := ChatGPT_Prompt "`n`n" CopiedText
        ChatGPT_Prompt := RegExReplace(ChatGPT_Prompt, '(\\|")+', '\$1') ; Clean back spaces and quotes
        ChatGPT_Prompt := RegExReplace(ChatGPT_Prompt, "`n", "\n") ; Clean newlines
        ChatGPT_Prompt := RegExReplace(ChatGPT_Prompt, "`r", "") ; Remove carriage returns
        global Previous_ChatGPT_Prompt := ChatGPT_Prompt
        global Previous_Status_Message := Status_Message
        global Previous_API_Model := API_Model
        global Response_Window_Status
    }

    OnMessage 0x200, WM_MOUSEHOVER
    Response.Value := Status_Message
    if (Response_Window_Status = "Closed") {
        Response_Window.Show("AutoSize Center")
        Response_Window_Status := "Open"
        RetryButton.Enabled := 0
        CopyButton.Enabled := 0
    } 
    DllCall("SetFocus", "Ptr", 0)

    global HTTP_Request := ComObject("WinHttp.WinHttpRequest.5.1")
    HTTP_Request.open("POST", API_URL, true)
    HTTP_Request.SetRequestHeader("Content-Type", "application/json")
    HTTP_Request.SetRequestHeader("Authorization", "Bearer " API_Key)
    Messages := '{ "role": "user", "content": "' ChatGPT_Prompt '" }'
    JSON_Request := '{ "model": "' API_Model '", "messages": [' Messages '] }'
    HTTP_Request.SetTimeouts(60000, 60000, 60000, 60000)
    HTTP_Request.Send(JSON_Request)
    SetTimer LoadingCursor, 1
    if WinExist("Response") {
        WinActivate "Response"
    }
    HTTP_Request.WaitForResponse
    try {
        if (HTTP_Request.status == 200) {
            SafeArray := HTTP_Request.responseBody
            pData := NumGet(ComObjValue(SafeArray) + 8 + A_PtrSize, 'Ptr')
            length := SafeArray.MaxIndex() + 1
            JSON_Response := StrGet(pData, length, 'UTF-8')
            var := Jxon_Load(&JSON_Response)
            JSON_Response := var.Get("choices")[1].Get("message").Get("content")
            RetryButton.Enabled := 1
            CopyButton.Enabled := 1
            Response.Value := JSON_Response

            SetTimer LoadingCursor, 0
            OnMessage 0x200, WM_MOUSEHOVER, 0
            Cursor := DllCall("LoadCursor", "uint", 0, "uint", 32512) ; Arrow cursor
            DllCall("SetCursor", "UPtr", Cursor)

            Response_Window.Flash()
            DllCall("SetFocus", "Ptr", 0)
        } else {
            RetryButton.Enabled := 1
            CopyButton.Enabled := 1
            Response.Value := "Status " HTTP_Request.status " " HTTP_Request.responseText

            SetTimer LoadingCursor, 0
            OnMessage 0x200, WM_MOUSEHOVER, 0
            Cursor := DllCall("LoadCursor", "uint", 0, "uint", 32512) ; Arrow cursor
            DllCall("SetCursor", "UPtr", Cursor)

            Response_Window.Flash()
            DllCall("SetFocus", "Ptr", 0)
        }
    }
}

/*
====================================================
游标
====================================================
*/

WM_MOUSEHOVER(*) {
    Cursor := DllCall("LoadCursor", "uint", 0, "uint", 32648) ; Unavailable cursor
    MouseGetPos ,,, &MousePosition
    if (CopyButton.Enabled = 0) & (MousePosition = "Button2") {
        DllCall("SetCursor", "UPtr", Cursor)
    } else if (RetryButton.Enabled = 0) & (MousePosition = "Button1") | (MousePosition = "Button2") {
        DllCall("SetCursor", "UPtr", Cursor)
    }
}

LoadingCursor() {
    MouseGetPos ,,, &MousePosition
    if (MousePosition = "Edit1") {
        Cursor := DllCall("LoadCursor", "uint", 0, "uint", 32514) ; Loading cursor
        DllCall("SetCursor", "UPtr", Cursor)
    }
}

/*
====================================================
热键
====================================================
*/

`::MenuPopup.Show()
