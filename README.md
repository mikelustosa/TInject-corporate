# Componente TInject Corporate
Componente para criação de chatBots com delphi<br>
<i>Component for creating chatBots with delphi</i><br></br>

## INSTRUÇÕES PARA USO DO COMPONENTE<br></br>

Compatibilidade testada nas seguintes versões do Delphi: Seattle, Berlim, Tokyo, Rio, Sydney, Athens.<br></br>

### Tutorial de instalação no youtube:<br>
https://www.youtube.com/watch?v=EIxFdtenNxI&t=31s

<br>
Videos demo:
<br>
https://youtu.be/YEmwghSGoFA
<br>
https://youtu.be/07RoReOHaT4
<br>
https://youtu.be/cbWW7VNYwEo
<br><br>

### NOVO: Para usar com o delphi 10.4 Sydney, incluir no library path 32 bits a pasta <b>Compilados</b> e suas subpastas.<br><br>

### Recursos / Resources<br><br>
✔️  Login<br>
✔️  Logout<br>
✔️  Confirmação de entrega de mensagens - Message delivery confirmation<br>
✔️  Enviar mensagens de texto com botão e lista - Send text message with button and list<br>
❌  Enviar mensagens de texto com botões - Send text message with buttons<br>
❌  Enviar mensagens de texto e imagem com botões - Send text and imagem message with buttons<br>
✔️  Enviar mensagens de texto para números fora da agenda - Send text message<br>
✔️  Enviar mensagens para grupos - Send group messages<br>
✔️  Enviar contatos - Send phone contacts<br>
✔️  Enviar chave PIX<br>
✔️  Enviar MP3 - Send MP3<br>
✔️  Enviar MP4 - Send MP4<br>
✔️  Enviar IMG - Send IMG<br>
✔️  Enviar RAR - Send RAR<br>
✔️  Enviar Link com prévia - Sending and preview (Não compatível com o multi device)<br>
✔️  Enviar localização - Location sending<br>
✔️  Enviar Stickers - Send Stickers<br>
✔️  Listar contatos - Contact list<br>
✔️  Listar bate papos - Conversation list<br>
✔️  Status da bateria - Battery status (Não compatível com o multi device)<br>
✔️  Simular digitando - Typing simulation<br>
✔️  Recebimento de novas mensagem - Receiving new messages<br>
✔️  Configurações de DDI - International number configuration<br>
✔️  Validação de números - number validator<br>
✔️  Checagem de conexão - check connection<br>
✔️  Download de arquivos - Download files<br>
✔️  Download da foto de perfil - Download profile picture<br>
✔️  Criar grupo - Create group (Não compatível com o multi device)<br>
✔️  Sair do grupo - Leave the group (Não compatível com o multi device)<br>
✔️  Adicionar participante ao grupo - Add participant to the group (Não compatível com o multi device)<br>
✔️  Remover participante do grupo - Remove group member (Não compatível com o multi device)<br>
✔️  Promover participante adminstrador do grupo - Promote participant group administrator (Não compatível com o multi device)<br>
✔️  Despromover participanete adminstrador do grupo - Demote participating group administrator (Não compatível com o multi device)<br>
✔️  Listar todos os grupos - List all groups<br>
✔️  Listar participantes do grupo - List group participants<br>
✔️  Obter link convite de grupos - Get Group invitation link<br>
✔️  Entrar em grupo via link convite - Join group via invitation link<br>
✔️  Monitoramento automático em caso de atualizações disponíveis do WhatsApp - Automatic monitoring in case of available WhatsApp updates<br>

### Cursos do componente / Component lessions:<br>

[Clique aqui / Click where](http://mikelustosa.kpages.online/tinject)

### Official documentation:<br><br>

### Events that send messages<br>
| event           | Description                | Example                                                                              | return |
|-----------------|----------------------------|--------------------------------------------------------------------------------------|--------|
| send            | Send text message          | TInject1.send('55819999999@c.us', 'hello');                                          | onGetIsDelivered |
| sendButtons     | Send text message buttons  | TInject1.sendButtons('55819999999@c.us', 'Choose', [{buttonId: 'id1', buttonText:{displayText: 'SIM'}, type: 1}, type: 1}], 'Escolha uma opção'); | -      |
| sendFile        | Send file and text message | TInject1.SendFile('558199999999@c.us', 'c:\myFile.pdf', 'hello');                    | onGetIsDelivered |
| sendContact     | Send whatsapp contact      | TInject1.sendContact('destinationContact@c.us', 'contactToBeSent@c.us');             | -      |
| sendLinkPreview | Send preview link          | TInject1.sendLinkPreview('558199999999@c.us', 'https://youtube.com/video', 'hello'); | -      |
| sendLocation    | Send Location              | TInject1.sendLocation('55819999999@c.us', '-70.4078', '25.3789', 'my location');     |        |
| sendPixKey      | Send PIX Key               | TInject1.sendPixKey('55819999999@c.us', 'EMAIL or CPF or CNPJ or TELEFONE or ALEATÓRIO', 'Chave PIX', 'NAME');                    |        |
| sendStartTyping | Send start typing          | TInject1.sendStartTyping('55819999999@c.us');                                        |        |
| sendStopTyping  | Send stop typing           | TInject1.sendStopTyping('55819999999@c.us');                                         |        |
| sendSticker     | Send Stickers              | TInject1.sendSticker('55819999999@c.us', 'Long base64 where...');                    |        |<br><br>

### Verifications events<br>
| event                 | Description                                             | example                                              | event return      | return                       |
|-----------------------|---------------------------------------------------------|------------------------------------------------------|-------------------|------------------------------|
| CheckIsConnected      | Checks the connection between the device and whatsapp   | TInject1.CheckIsConnected();                         | OnIsConnected     | boolean                      |
| NewCheckIsValidNumber | Checks whether one or more numbers are whatsapp numbers | TInject1.NewCheckIsValidNumber('558199999999@c.us'); | OnNewGetNumber    | TReturnCheckNumber           |
