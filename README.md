# ChatGPT-AutoHotkey-Utility

[⏬ Download here](https://github.com/2631792752/ChatGPT-AutoHotkey-Utility/releases/latest)

一个使用ChatGPT API处理所选文本的AutoHotkey脚本。

![image](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/e5076d79-26ad-4680-83ee-032a6a805d40)

![image](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/3b1349c8-619f-4cf9-b82f-2289845a4b71)

## 如何使用

1. 安装[AutoHotkey v2](https://www.autohotkey.com/)。请注意，此脚本在之前的AutoHotkey版本上无法使用。
2. 将您的OpenAI API密钥复制到[此处](https://platform.openai.com/account/api-keys)（您可能需要创建新的密钥）。
3. 使用您喜欢的文本编辑器打开`ChatGPT AutoHotkey Utility.ahk`。
4. 将您的OpenAI API密钥粘贴到`API_Key`变量中。

![image](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/a77d1a7d-628b-4155-83ba-2b5569442a50)

5. 启动`ChatGPT AutoHotkey Utility.ahk`
6. 选择您想使用ChatGPT API处理的文本并按下"`反引号"`键来打开菜单。

![image](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/7615e7b5-c4f0-4a8f-9608-669a021ac38d)

(图片来自 [emacs.stackexchange.com](https://emacs.stackexchange.com/questions/16749/how-to-set-emacs-to-recognize-backtick-and-tilde-with-a-colemak-keyboard-layout))

## 自定义菜单、提示、API和热键

您可以通过以下方式自定义提示和菜单顺序：

### 菜单

在`菜单和ChatGPT提示词`下，通过添加以下代码添加一个菜单：

```AutoHotkey
MenuPopup.Add("&8 - Text_To_Appear", Function_To_Execute_When_Selected)
```

“和”符号(&)旁边的字符是该特定菜单的热键，按下时激活该菜单。

您也可以使用以下代码添加一条分隔线：

```AutoHotkey
MenuPopup.Add()
```

### 提示词

您可以使用以下代码添加一个提示词：

```AutoHotkey
Function_To_Execute_When_Selected(*) {
    ChatGPT_Prompt := "在这里输入您的提示："
    Status_Message := "处理请求时显示的状态消息"
    API_Model := "gpt-4" ; 或 API_Model := "gpt-3.5-turbo"
    ProcessRequest(ChatGPT_Prompt, Status_Message, API_Model, Retry_Status)
}
```

### API

您可以通过更改每个提示下的`API_Model`来编辑用于每个提示的API。

![76IxQa4](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/7bd23815-78d8-4629-b69b-7fcea3be5f28)

### 热键

您可以在热键下更改激活热键。请参阅[此处](https://www.autohotkey.com/docs/v2/KeyList.htm)以获取可能的热键列表。

![image](https://github.com/kdalanon/ChatGPT-AutoHotkey-Utility/assets/123705491/da257ab3-05d0-4779-87a2-0a2ba6270255)

## 鸣谢

- [AutoHotkey-JSON](https://github.com/cocobelgica/AutoHotkey-JSON) 库
- [ai-tools-ahk](https://github.com/ecornell/ai-tools-ahk) 提供的灵感
- [Icons8](https://icons8.com/icon/kTuxVYRKeKEY/chatgpt) 提供的图标
