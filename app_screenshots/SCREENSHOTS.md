# Screenshots do app Bloco na Rua

Duas pastas com o mesmo fluxo em dois temas:

- `screenshots-dark/` — tema escuro (Modo escuro = ligado)
- `screenshots-light/` — tema claro (Modo escuro = desligado)

Nomes dos arquivos são numerados na ordem da jornada.

## Como alternar o tema

`Perfil` (última aba do bottom nav) → seção **Aparência** → switch **Modo escuro**.
O tema é global e persistente, então vale capturar tudo de uma vez por tema.

## Pré-requisito: conta de teste

- e-mail: `joao@teste.com`
- senha: `12345678`
- telefone usado no cadastro: `(11) 98765-4321`

O cadastro é feito em `/register` (4 campos). Depois do cadastro o app loga sozinho e cai na Home.

## Coordenadas úteis (px lógicos, tela 411x899)

| Alvo                         | Coordenada  |
| ---------------------------- | ----------- |
| Bottom nav Início             | (51, 855)   |
| Bottom nav Blocos             | (154, 855)  |
| Bottom nav Encontros          | (257, 855)  |
| Bottom nav Perfil             | (360, 855)  |
| Criar Encontro (app bar)      | (323, 82)   |
| Editar Bloco (app bar)        | (379, 82)   |
| FAB (Blocos)                  | (355, 800)  |
| Card do bloco na lista        | (200, 160)  |
| TextButton Membros (no bloco) | (336, 658)  |
| Picker de data (novo encontro)| (115, 378)  |
| Picker de hora (novo encontro)| (297, 378)  |
| OK do date picker             | (346, 735)  |
| OK do time picker             | (329, 687)  |

Seletores por key são mais confiáveis para digitar (`enter_text`), mas para tapping use coordenadas — keys repetem entre rotas.

---

## Jornada

### 1. Cadastro — `/register`

Chegue por `Login` → link **"Não tem uma conta? Cadastre-se"**.
Preencha `app_text_field_Nome`, `app_text_field_E-mail`, `app_text_field_Senha`, `app_text_field_Telefone` (máscara, min. 14 chars, senha min. 8).
`app_button_Cadastrar` só habilita com os 4 válidos. Erros aparecem campo a campo.

`dark/01`, `dark/04` · `light/18`, `light/19`

### 2. Login — `/login`

App sempre abre aqui sem sessão válida (`redirect` do GoRouter manda para `/login`).
Links: **"Esqueceu a senha?"** e **"Não tem uma conta? Cadastre-se"**.
`app_button_Entrar` só habilita com e-mail + senha preenchidos.

`dark/02`, `dark/03` · `light/01`

### 3. Recuperar senha (dialog, não é rota)

Toque **"Esqueceu a senha?"** na tela de login → dialog com `app_text_field_E-mail`, `app_button_Enviar`, `app_button_Cancelar`.

`light/02`

### 4. Home — `/`

Greeting "Olá!", subtítulo "Veja seus blocos e encontros", seções **Meus blocos** e **Próximos encontros** (cada uma com "Ver todos"), botões `app_button_Criar bloco` / `app_button_Entrar em bloco` no estado vazio, FAB `app_fab_null`, bottom nav com 4 abas.

`dark/05` · `light/03`

### 5. Blocos — `/carnival-blocks`

Lista com `block_card_<id>`. Estado vazio mostra "Nenhum bloco ainda" + botão de criar.
O FAB `app_fab_null` expande em speed-dial com dois botões: **"Criar Bloco"** e **"Entrar em Bloco"** (o texto não aparece na árvore de semântica, mas o tap por texto funciona).

`dark/06`, `dark/07` · `light/04`, `light/20`

### 6. Criar bloco — `/create-block`

Um campo só: `app_text_field_Nome do bloco`. `app_button_Criar` cria e navega para `/carnival-block/:id`, com snackbar "Bloco criado com sucesso!".

`dark/09` · `light/21`

### 7. Entrar em bloco — `/join-block`

Campo `app_text_field_Código de convite` + `app_button_Entrar`.

`dark/08` · `light/22`

### 8. Detalhes do bloco — `/carnival-block/:id`

App bar "Detalhes do Bloco" com **Criar Encontro** (323,82) e **Editar Bloco** (379,82).
Cartão com **Código de convite** e **Código de gestor** (o de gestor vem mascarado, com botão de copiar `app_icon_button_null`).
Seções **Encontros** e **Membros**; cada uma com TextButton de ação à direita.
Membros aparece separado em "Moderadores (n)" e "Participantes (n)".

`dark/10`, `dark/14`, `dark/19` · `light/05`, `light/12`

### 9. Editar bloco — `/edit-block/:id`

`app_text_field_Nome do bloco`, seletor de imagem ("Sem imagem"), `app_button_Salvar alterações` (só habilita se o nome mudar), `app_button_Excluir bloco`.

`dark/17` · `light/06`

### 10. Adicionar membro — `/add-member/:blockId`

Busca global por nome/e-mail: `app_search_field_Buscar por nome ou email`, cards `member_card_<id>` com botão "Adicionar membro" (`app_icon_button_Adicionar membro`).
Depois de adicionar, o membro aparece em Participantes no bloco.

`dark/18`, `dark/19` · `light/07`

### 11. Criar encontro — `/create-meeting/:blockId`

Campos: `app_text_field_Título do encontro`, `app_text_field_Descrição`, pickers de data e hora (GestureDetector), `app_text_field_Local`.
`app_button_Criar encontro` só habilita com data + hora preenchidas.

`dark/13` · `light/08`, `light/11`

### 12. Date picker

Toca no picker de data → dialog "Selecione a data". Default = hoje. Botões Cancelar (222,735) e OK (346,735).

`dark/11` · `light/09`

### 13. Time picker

Toca no picker de hora → dialog "Selecione o horário", formato 24h. Cancelar (205,687) e OK (329,687).

`dark/12` · `light/10`

### 14. Detalhes do encontro — `/meeting/:id`

Título, nome do bloco, descrição, data formatada ("sábado, 24/10/2026 • 14:18"), local, chip de status.
**Lista de Presença** com contador X/Y, `app_search_field_Buscar membro...`, botão `button_confirm_presence` (RSVP) e cards `member_card_<id>`.
Ícone de "Ordenar e filtrar" abre sort/filtro (inclui "Nome (A-Z)").
Confirmar presença dispara snackbar "Presença atualizada com sucesso!" e o contador sobe.

`dark/15`, `dark/16` · `light/13`

### 15. Encontros — `/user-meetings`

Busca (`app_search_field_Buscar encontros...`), cards `meeting_card_<id>` com nome do bloco, data, local e chip de confirmação.

`dark/20` · `light/14`

### 16. Perfil — `/profile`

Avatar com badge de lápis (hoje só mostra snackbar "Editar perfil em breve"), nome, e-mail.
**Aparência**: switch *Modo escuro*. **Informações**: Telefone + Membro desde. **Conta**: `app_button_Sair da conta` (abre AlertDialog "Sair" com Cancelar/Sair).

`dark/21`, `dark/22` · `light/15`, `light/16`, `light/17`

---

## Armadilhas

- **Back em rota raiz fecha o app.** `/login` e `/register` são raízes — o back não faz pop, mata o processo. Depois disso o `flutter run` relança com novo VM service URI e o usuário desloga. Reconecte o marionette antes de continuar.
- **Taps por key colidem entre rotas** (ex.: `app_text_field_E-mail` existe no login, no dialog de recuperação e no cadastro). Prefira coordenadas ou `ancestor_keys`.
- **Tap por type "IconButton" pega o primeiro da tela** — use coordenadas para os ícones do app bar.
- A árvore de semântica já veio desatualizada uma vez (mostrou Perfil quando a tela era outra). Screenshots são a fonte confiável.
