// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get network => 'Sem conexão com a internet. Verifique sua rede Wi-Fi.';

  @override
  String get timeout =>
      'Conexão lenta. Verifique sua internet ou tente novamente.';

  @override
  String get server503 =>
      'Servidor temporariamente indisponível. Tente novamente mais tarde.';

  @override
  String get server5xx => 'Erro no servidor. Tente novamente mais tarde.';

  @override
  String get authExpired => 'Sessão expirada. Faça login novamente.';

  @override
  String get authForbidden => 'Você não tem permissão para esta ação.';

  @override
  String get notFound => 'Recurso não encontrado.';

  @override
  String get validation => 'Dados inválidos. Verifique as informações.';

  @override
  String get unknown => 'Algo inesperado aconteceu. Tente novamente.';

  @override
  String get authAppTitle => 'Bloco na Rua';

  @override
  String get authBackButton => 'Voltar';

  @override
  String get authAccountCreated => 'Conta criada. Faça login.';

  @override
  String get authRecoveryEmailSent => 'E-mail de recuperação enviado!';

  @override
  String get loginTitle => 'Bem vindo';

  @override
  String get loginSubtitle => 'Entre para organizar seu bloco';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailRequired => 'Por favor, insira um e-mail';

  @override
  String get loginEmailInvalid => 'E-mail inválido';

  @override
  String get loginInvalidCredentials => 'E-mail ou senha inválidos.';

  @override
  String get signupEmailInUse => 'Este e-mail já está em uso.';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordRequired => 'Por favor, insira uma senha';

  @override
  String get loginShowPassword => 'Mostrar senha';

  @override
  String get loginHidePassword => 'Ocultar senha';

  @override
  String get loginEnterButton => 'Entrar';

  @override
  String get loginGoogleButton => 'Entrar com o Google';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String loginRecoveryMessage(String email) {
    return 'Enviaremos um link de recuperação para $email';
  }

  @override
  String get loginSendButton => 'Enviar';

  @override
  String get loginCancel => 'Cancelar';

  @override
  String get loginRegisterLink => 'Não tem uma conta? Cadastre-se';

  @override
  String get signupTitle => 'Crie sua conta';

  @override
  String get signupSubtitle => 'Junte-se à folia';

  @override
  String get signupNameLabel => 'Nome';

  @override
  String get signupNameRequired => 'Por favor, insira seu nome';

  @override
  String get signupEmailLabel => 'E-mail';

  @override
  String get signupEmailRequired => 'Por favor, insira um e-mail';

  @override
  String get signupEmailInvalid => 'E-mail inválido';

  @override
  String get signupPasswordLabel => 'Senha';

  @override
  String get signupPasswordRequired => 'Por favor, insira uma senha';

  @override
  String get signupPasswordMinLength =>
      'A senha deve ter no mínimo 8 caracteres';

  @override
  String get signupPasswordHelper => 'Mínimo 8 caracteres';

  @override
  String get signupPhoneLabel => 'Telefone';

  @override
  String get signupPhoneRequired => 'Por favor, insira um telefone';

  @override
  String get signupPhoneInvalid => 'Telefone inválido';

  @override
  String get signupSubmitButton => 'Cadastrar';

  @override
  String get signupLoginLink => 'Já tem uma conta? Faça login';

  @override
  String get logoutTitle => 'Sair da conta';

  @override
  String get logoutMessage =>
      'Você precisará fazer login novamente para acessar o app.';

  @override
  String get logoutConfirm => 'Sair';

  @override
  String get logoutCancel => 'Cancelar';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileAppearanceSection => 'Aparência';

  @override
  String get profileInformationSection => 'Informações';

  @override
  String get profileAccountSection => 'Conta';

  @override
  String get profilePhoneLabel => 'Telefone';

  @override
  String get profileNotAuthenticated => 'Usuário não autenticado';

  @override
  String get profileNotInformed => 'Não informado';

  @override
  String get profileMemberSince => 'Membro desde';

  @override
  String get profileNotAvailable => 'Não disponível';

  @override
  String get profileDarkMode => 'Modo escuro';

  @override
  String get profileChangePhotoLabel => 'Alterar foto de perfil';

  @override
  String get profileEditSoon => 'Editar perfil em breve';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAccountSection => 'Conta';

  @override
  String get blocksListTitle => 'Blocos';

  @override
  String get blocksLoadingList => 'Carregando blocos...';

  @override
  String get blocksEmptyTitle => 'Nenhum bloco ainda';

  @override
  String get blocksEmptyMessage =>
      'Crie um bloco para começar a organizar seu carnaval';

  @override
  String get blocksCreateAction => 'Criar bloco';

  @override
  String get blocksCreateTitle => 'Criar bloco';

  @override
  String get blocksCreateHeadline => 'Crie seu bloco';

  @override
  String get blocksCreateSubtitle =>
      'Dê um nome ao seu bloco de rua e comece a organizar!';

  @override
  String get blocksCreate => 'Criar';

  @override
  String get blocksCreateSuccess => 'Bloco criado com sucesso!';

  @override
  String get blocksEditTitle => 'Editar bloco';

  @override
  String get blocksUpdateSuccess => 'Bloco atualizado com sucesso';

  @override
  String get blocksDeleteSuccess => 'Bloco excluído com sucesso';

  @override
  String get blocksDeleteTitle => 'Excluir bloco';

  @override
  String get blocksDeleteConfirmMessage =>
      'Tem certeza que deseja excluir este bloco? Esta ação não pode ser desfeita.';

  @override
  String get blocksDeleteConfirm => 'Excluir';

  @override
  String get blocksCancel => 'Cancelar';

  @override
  String get blocksLoadingBlock => 'Carregando bloco...';

  @override
  String get blocksSaveChanges => 'Salvar alterações';

  @override
  String get blocksImageLabel => 'Imagem do bloco';

  @override
  String get blocksNoImage => 'Sem imagem';

  @override
  String get blockNameLabel => 'Nome do bloco';

  @override
  String get blockNameHint => 'Ex.: Bloco da Saudade';

  @override
  String get blockNameRequired => 'Digite um nome para o bloco';

  @override
  String get blockNameTooShort => 'Nome muito curto';

  @override
  String get blockNameTooLong => 'Nome muito longo';

  @override
  String get blockEditNameHint => 'Ex: Bloco da Vizinhança';

  @override
  String get blocksJoinTitle => 'Entrar em bloco';

  @override
  String get blocksJoinHeadline => 'Entre em um bloco';

  @override
  String get blocksJoinSubtitle =>
      'Peça o código de convite ao dono do bloco para entrar.';

  @override
  String get blocksInviteCodeLabel => 'Código de convite';

  @override
  String get blocksInviteCodeHint => 'Cole aqui o código';

  @override
  String get blocksInviteCodeRequired => 'Digite o código de convite';

  @override
  String get blocksInviteCodeTooShort => 'Código muito curto';

  @override
  String get blocksJoinSubmit => 'Entrar';

  @override
  String get blocksJoinSuccess => 'Você entrou no bloco!';

  @override
  String get blocksEmptyInviteCode =>
      'O código de convite não pode estar vazio.';

  @override
  String get blocksInvalidId => 'ID do bloco inválido';

  @override
  String get blocksNotFound => 'Bloco não encontrado';

  @override
  String get blocksNotFoundMessage => 'Este bloco não está disponível.';

  @override
  String blocksUserDataError(String message) {
    return 'Erro ao obter dados do usuário: $message';
  }

  @override
  String blocksUnexpectedError(String message) {
    return 'Erro inesperado: $message';
  }

  @override
  String blocksJoinFailed(String message) {
    return 'Erro ao entrar no bloco: $message';
  }

  @override
  String get blocksAddMemberTitle => 'Adicionar membro';

  @override
  String get blocksMemberSearchHint => 'Buscar por nome ou email';

  @override
  String get blocksMemberNotFoundTitle => 'Nenhum membro encontrado';

  @override
  String get blocksMemberNotFoundMessage =>
      'Tente buscar por outro nome ou email.';

  @override
  String get blocksNoMemberTitle => 'Nenhum membro disponível';

  @override
  String get blocksNoMemberMessage =>
      'Não há membros para adicionar a este bloco.';

  @override
  String blocksAddMemberTooltip(String name) {
    return 'Adicionar $name ao bloco';
  }

  @override
  String get blocksMemberAddedSuccess => 'Membro adicionado com sucesso';

  @override
  String get blocksDetailsTitle => 'Detalhes do Bloco';

  @override
  String get blocksCreateMeeting => 'Criar Encontro';

  @override
  String get blocksEditBlock => 'Editar Bloco';

  @override
  String get blocksAdd => 'Adicionar';

  @override
  String get blocksMeetingsSection => 'Encontros';

  @override
  String get blocksMembersSection => 'Membros';

  @override
  String get blocksInviteCodeTitle => 'Código de convite';

  @override
  String get blocksManagerCodeTitle => 'Código de gestor';

  @override
  String get blocksCodeCopied => 'Código copiado!';

  @override
  String blocksShowCode(String title) {
    return 'Mostrar $title';
  }

  @override
  String blocksHideCode(String title) {
    return 'Ocultar $title';
  }

  @override
  String blocksCopyCode(String title) {
    return 'Copiar $title';
  }

  @override
  String get blocksLoadingMeetings => 'Carregando encontros...';

  @override
  String get blocksNoMeetingsYet => 'Nenhum encontro ainda';

  @override
  String get blocksNoTitle => 'Sem título';

  @override
  String get blocksLoadingMembers => 'Carregando membros...';

  @override
  String get blocksNoMembersYet => 'Nenhum membro ainda';

  @override
  String get blocksAdminsGroup => 'Admins';

  @override
  String get blocksModeratorsGroup => 'Moderadores';

  @override
  String blocksGroupCount(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get blocksMemberFallback => 'Membro';

  @override
  String blocksRemoveMemberTooltip(String name) {
    return 'Remover $name do bloco';
  }

  @override
  String get blocksRemoveMemberTitle => 'Remover membro';

  @override
  String get blocksRemoveMemberConfirm => 'Remover este membro do bloco?';

  @override
  String get blocksRemoveMemberAction => 'Remover';

  @override
  String get blocksRemoveMemberSuccess => 'Membro removido com sucesso';

  @override
  String blocksRemoveMemberError(String message) {
    return 'Erro ao remover membro: $message';
  }

  @override
  String blocksMembersLoadFailed(int count) {
    return 'Falha ao carregar dados de $count membro(s)';
  }

  @override
  String get blocksRoleAdmin => 'Admin';

  @override
  String get blocksRoleModerator => 'Moderador';

  @override
  String get blocksRoleMember => 'Membro';

  @override
  String get meetingsListTitle => 'Encontros';

  @override
  String get meetingsSearchHint => 'Buscar encontros...';

  @override
  String get meetingsNoMeetingTitle => 'Nenhum encontro';

  @override
  String get meetingsNoMeetingMessage =>
      'Você ainda não tem encontros agendados';

  @override
  String get meetingsNoMeetingFoundTitle => 'Nenhum encontro encontrado';

  @override
  String get meetingsNoMeetingFoundMessage => 'Tente buscar com outros termos';

  @override
  String get meetingsCreateTitle => 'Novo encontro';

  @override
  String get meetingsEditTitle => 'Editar encontro';

  @override
  String get meetingsDetailsTitle => 'Detalhes do Encontro';

  @override
  String get meetingsTitleLabel => 'Título do encontro';

  @override
  String get meetingsTitleHint => 'Ex.: Ensaio geral';

  @override
  String get meetingsTitleRequired =>
      'Por favor, insira um nome para o encontro';

  @override
  String get meetingsEditTitleRequired => 'O título do encontro é obrigatório';

  @override
  String get meetingsDescriptionLabel => 'Descrição';

  @override
  String get meetingsDescriptionHint => 'Detalhes sobre o encontro (opcional)';

  @override
  String get meetingsDateLabel => 'Data';

  @override
  String get meetingsTimeLabel => 'Hora';

  @override
  String get meetingsDateTimeLabel => 'Data e hora';

  @override
  String get meetingsSelectHint => 'Selecione';

  @override
  String get meetingsSelectDate => 'Selecione a data';

  @override
  String get meetingsSelectTime => 'Selecione a hora';

  @override
  String get meetingsSelectDateSemantics => 'Selecionar data';

  @override
  String get meetingsSelectTimeSemantics => 'Selecionar hora';

  @override
  String get meetingsSelectDateTimeSemantics => 'Selecionar data e hora';

  @override
  String get meetingsLocationLabel => 'Local';

  @override
  String get meetingsLocationHint => 'Ex.: Praça central';

  @override
  String get meetingsLocationRequired =>
      'Por favor, insira um local para o encontro';

  @override
  String get meetingsCreateButton => 'Criar encontro';

  @override
  String get meetingsSaveButton => 'Salvar alterações';

  @override
  String get meetingsCreateSuccess => 'Encontro criado com sucesso';

  @override
  String get meetingsCreateError => 'Erro ao criar encontro. Tente novamente.';

  @override
  String get meetingsUpdateSuccess => 'Encontro atualizado com sucesso!';

  @override
  String get meetingsInvalidBlockId => 'ID do bloco inválido';

  @override
  String get meetingsInvalidMeetingId => 'ID do encontro inválido';

  @override
  String get meetingsUnknownError => 'Erro desconhecido';

  @override
  String get meetingsPresenceUpdated => 'Presença atualizada com sucesso!';

  @override
  String get meetingsDeleteError => 'Erro ao excluir encontro';

  @override
  String get meetingsDeleteTitle => 'Excluir encontro';

  @override
  String get meetingsDeleteConfirmMessage =>
      'Tem certeza que deseja excluir este encontro? Esta ação não pode ser desfeita.';

  @override
  String get meetingsDeleteAction => 'Excluir';

  @override
  String get meetingsCancel => 'Cancelar';

  @override
  String get meetingsConfirm => 'Confirmar';

  @override
  String get meetingsPresenceListTitle => 'Lista de Presença';

  @override
  String get meetingsConfirmPresence => 'Confirmar Presença';

  @override
  String get meetingsStatusUpcoming => 'Próxima';

  @override
  String get meetingsStatusDone => 'Realizada';

  @override
  String get meetingsStatusSoon => 'Em breve';

  @override
  String get meetingsPresent => 'Presente';

  @override
  String get meetingsAbsent => 'Ausente';

  @override
  String get meetingsMemberFallback => 'Membro';

  @override
  String meetingsMemberNumber(int id) {
    return 'Membro #$id';
  }

  @override
  String get meetingsLoadingPresences => 'Carregando presenças...';

  @override
  String get meetingsNoPresenceYet => 'Ninguém confirmou presença ainda';

  @override
  String get meetingsNoMemberFound => 'Nenhum membro encontrado';

  @override
  String get meetingsSearchMemberHint => 'Buscar membro...';

  @override
  String meetingsMarkPresenceOf(String name) {
    return 'Marcar presença de $name';
  }

  @override
  String get meetingsChangePresenceTitle => 'Alterar presença';

  @override
  String meetingsMarkPresent(String name) {
    return 'Marcar $name como presente?';
  }

  @override
  String meetingsMarkAbsent(String name) {
    return 'Marcar $name como ausente?';
  }

  @override
  String get meetingsSortFilterTooltip => 'Ordenar e filtrar';

  @override
  String get meetingsSortHeader => 'Ordenar';

  @override
  String get meetingsSortByName => 'Nome (A-Z)';

  @override
  String get meetingsSortPresentFirst => 'Presentes primeiro';

  @override
  String get meetingsSortAbsentFirst => 'Ausentes primeiro';

  @override
  String get meetingsFilterHeader => 'Filtrar';

  @override
  String get meetingsFilterAll => 'Todos';

  @override
  String get meetingsFilterPresent => 'Presentes';

  @override
  String get meetingsFilterAbsent => 'Ausentes';

  @override
  String get meetingsNoData => 'Nenhum dado encontrado';

  @override
  String get homeAppTitle => 'Bloco na Rua';

  @override
  String get homeGreeting => 'Olá!';

  @override
  String get homeSubtitle => 'Veja seus blocos e encontros';

  @override
  String get homeMyBlocks => 'Meus blocos';

  @override
  String get homeSeeAll => 'Ver todos';

  @override
  String get homeNoBlocks => 'Nenhum bloco ainda';

  @override
  String get homeCreateBlock => 'Criar bloco';

  @override
  String get homeJoinBlock => 'Entrar em bloco';

  @override
  String get homeUpcomingMeetings => 'Próximos encontros';

  @override
  String get homeNoMeetingsThisWeek => 'Nenhum encontro esta semana';

  @override
  String get errorTitle => 'Erro';

  @override
  String get errorUnexpected => 'Ocorreu um erro inesperado.';

  @override
  String get notFoundTitle => 'Página não encontrada';

  @override
  String get notFoundMessage => 'A página que você procura não existe.';

  @override
  String get coreBack => 'Voltar';

  @override
  String get coreErrorTitle => 'Algo deu errado';

  @override
  String get coreRetry => 'Tentar novamente';

  @override
  String get coreLoading => 'Carregando...';

  @override
  String get coreSearchHint => 'Pesquisar...';

  @override
  String get coreClearSearch => 'Limpar busca';

  @override
  String get coreFabCreateOrJoinBlock => 'Criar ou entrar em bloco';

  @override
  String get coreFabCreateBlock => 'Criar Bloco';

  @override
  String get coreFabJoinBlock => 'Entrar em Bloco';

  @override
  String get coreDateNotSet => 'Data não definida';

  @override
  String get coreMeetingFallback => 'Encontro';

  @override
  String corePresencesCount(int confirmed, int total) {
    return '$confirmed/$total presenças';
  }

  @override
  String get corePresenceConfirmed => 'Confirmada';

  @override
  String get corePresencePending => 'Pendente';

  @override
  String get corePresencePartial => 'Parcial';

  @override
  String get coreLive => 'Ao vivo';

  @override
  String get coreNoName => 'Sem nome';

  @override
  String get navHome => 'Início';

  @override
  String get navHomeTooltip => 'Ir para o início';

  @override
  String get navBlocks => 'Blocos';

  @override
  String get navBlocksTooltip => 'Ver os blocos';

  @override
  String get navMeetings => 'Encontros';

  @override
  String get navMeetingsTooltip => 'Ver os encontros';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navProfileTooltip => 'Abrir o perfil';

  @override
  String get onboarding1Title => 'O que é um bloco?';

  @override
  String get onboarding1Body =>
      'Um bloco de carnaval é um grupo de pessoas que se unen para celebrar juntos durante o período carnavalesco. Cada bloco tem sua própria identidade, música e tradição.';

  @override
  String get onboarding2Title => 'Crie ou entre em um bloco';

  @override
  String get onboarding2Body =>
      'Junte-se a um bloco existente ou crie o seu próprio. Convide amigos e familiares para fazer parte da folia!';

  @override
  String get onboarding3Title => 'Confirme presença nos encontros';

  @override
  String get onboarding3Body =>
      'Veja os encontros do seu bloco e confirme sua presença. Nunca mais perca um encontro!';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingStart => 'Começar';

  @override
  String get meetingsNotAuthenticated => 'Usuário não autenticado';
}
