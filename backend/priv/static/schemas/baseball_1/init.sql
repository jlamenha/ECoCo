-- Database: baseball_1

CREATE TABLE baseball_1.all_star (
    player_id TEXT,
    year INTEGER,
    game_num INTEGER,
    game_id TEXT,
    team_id TEXT,
    league_id TEXT,
    gp INTEGER,
    starting_pos INTEGER
);

CREATE TABLE baseball_1.appearances (
    year INTEGER,
    team_id TEXT,
    league_id TEXT,
    player_id TEXT,
    g_all INTEGER,
    gs INTEGER,
    g_batting INTEGER,
    g_defense INTEGER,
    g_p INTEGER,
    g_c INTEGER,
    g_1b INTEGER,
    g_2b INTEGER,
    g_3b INTEGER,
    g_ss INTEGER,
    g_lf INTEGER,
    g_cf INTEGER,
    g_rf INTEGER,
    g_of INTEGER,
    g_dh INTEGER,
    g_ph INTEGER,
    g_pr INTEGER
);

CREATE TABLE baseball_1.manager_award (
    player_id TEXT,
    award_id TEXT,
    year INTEGER,
    league_id TEXT,
    tie TEXT,
    notes INTEGER
);

CREATE TABLE baseball_1.player_award (
    player_id TEXT,
    award_id TEXT,
    year INTEGER,
    league_id TEXT,
    tie TEXT,
    notes TEXT
);

CREATE TABLE baseball_1.manager_award_vote (
    award_id TEXT,
    year INTEGER,
    league_id TEXT,
    player_id TEXT,
    points_won INTEGER,
    points_max INTEGER,
    votes_first INTEGER
);

CREATE TABLE baseball_1.player_award_vote (
    award_id TEXT,
    year INTEGER,
    league_id TEXT,
    player_id TEXT,
    points_won INTEGER,
    points_max INTEGER,
    votes_first INTEGER
);

CREATE TABLE baseball_1.batting (
    player_id TEXT,
    year INTEGER,
    stint INTEGER,
    team_id TEXT,
    league_id TEXT,
    g INTEGER,
    ab INTEGER,
    r INTEGER,
    h INTEGER,
    double INTEGER,
    triple INTEGER,
    hr INTEGER,
    rbi INTEGER,
    sb INTEGER,
    cs INTEGER,
    bb INTEGER,
    so INTEGER,
    ibb INTEGER,
    hbp INTEGER,
    sh INTEGER,
    sf INTEGER,
    g_idp INTEGER
);

CREATE TABLE baseball_1.batting_postseason (
    year INTEGER,
    round TEXT,
    player_id TEXT,
    team_id TEXT,
    league_id TEXT,
    g INTEGER,
    ab INTEGER,
    r INTEGER,
    h INTEGER,
    double INTEGER,
    triple INTEGER,
    hr INTEGER,
    rbi INTEGER,
    sb INTEGER,
    cs INTEGER,
    bb INTEGER,
    so INTEGER,
    ibb INTEGER,
    hbp INTEGER,
    sh INTEGER,
    sf INTEGER,
    g_idp INTEGER
);

CREATE TABLE baseball_1.player_college (
    player_id TEXT,
    college_id TEXT,
    year INTEGER
);

CREATE TABLE baseball_1.fielding (
    player_id TEXT,
    year INTEGER,
    stint INTEGER,
    team_id TEXT,
    league_id TEXT,
    pos TEXT,
    g INTEGER,
    gs INTEGER,
    inn_outs INTEGER,
    po INTEGER,
    a INTEGER,
    e INTEGER,
    dp INTEGER,
    pb INTEGER,
    wp INTEGER,
    sb INTEGER,
    cs INTEGER,
    zr INTEGER
);

CREATE TABLE baseball_1.fielding_outfield (
    player_id TEXT,
    year INTEGER,
    stint INTEGER,
    glf INTEGER,
    gcf INTEGER,
    grf INTEGER
);

CREATE TABLE baseball_1.fielding_postseason (
    player_id TEXT,
    year INTEGER,
    team_id TEXT,
    league_id TEXT,
    round TEXT,
    pos TEXT,
    g INTEGER,
    gs INTEGER,
    inn_outs INTEGER,
    po INTEGER,
    a INTEGER,
    e INTEGER,
    dp INTEGER,
    tp INTEGER,
    pb INTEGER,
    sb INTEGER,
    cs INTEGER
);

CREATE TABLE baseball_1.hall_of_fame (
    player_id TEXT,
    yearid INTEGER,
    votedby TEXT,
    ballots INTEGER,
    needed INTEGER,
    votes INTEGER,
    inducted TEXT,
    category TEXT,
    needed_note TEXT
);

CREATE TABLE baseball_1.home_game (
    year INTEGER,
    league_id TEXT,
    team_id TEXT,
    park_id TEXT,
    span_first TEXT,
    span_last TEXT,
    games INTEGER,
    openings INTEGER,
    attendance INTEGER
);

CREATE TABLE baseball_1.manager (
    player_id TEXT,
    year INTEGER,
    team_id TEXT,
    league_id TEXT,
    inseason INTEGER,
    g INTEGER,
    w INTEGER,
    l INTEGER,
    rank INTEGER,
    plyr_mgr TEXT
);

CREATE TABLE baseball_1.manager_half (
    player_id TEXT,
    year INTEGER,
    team_id TEXT,
    league_id TEXT,
    inseason INTEGER,
    half INTEGER,
    g INTEGER,
    w INTEGER,
    l INTEGER,
    rank INTEGER
);

CREATE TABLE baseball_1.player (
    player_id TEXT,
    birth_year INTEGER,
    birth_month INTEGER,
    birth_day INTEGER,
    birth_country TEXT,
    birth_state TEXT,
    birth_city TEXT,
    death_year INTEGER,
    death_month INTEGER,
    death_day INTEGER,
    death_country TEXT,
    death_state TEXT,
    death_city TEXT,
    name_first TEXT,
    name_last TEXT,
    name_given TEXT,
    weight INTEGER,
    height INTEGER,
    bats TEXT,
    throws TEXT,
    debut TEXT,
    final_game TEXT,
    retro_id TEXT,
    bbref_id TEXT
);

CREATE TABLE baseball_1.park (
    park_id TEXT,
    park_name TEXT,
    park_alias TEXT,
    city TEXT,
    state TEXT,
    country TEXT
);

CREATE TABLE baseball_1.pitching (
    player_id TEXT,
    year INTEGER,
    stint INTEGER,
    team_id TEXT,
    league_id TEXT,
    w INTEGER,
    l INTEGER,
    g INTEGER,
    gs INTEGER,
    cg INTEGER,
    sho INTEGER,
    sv INTEGER,
    ipouts INTEGER,
    h INTEGER,
    er INTEGER,
    hr INTEGER,
    bb INTEGER,
    so INTEGER,
    baopp INTEGER,
    era INTEGER,
    ibb INTEGER,
    wp INTEGER,
    hbp INTEGER,
    bk INTEGER,
    bfp INTEGER,
    gf INTEGER,
    r INTEGER,
    sh INTEGER,
    sf INTEGER,
    g_idp INTEGER
);

CREATE TABLE baseball_1.pitching_postseason (
    player_id TEXT,
    year INTEGER,
    round TEXT,
    team_id TEXT,
    league_id TEXT,
    w INTEGER,
    l INTEGER,
    g INTEGER,
    gs INTEGER,
    cg INTEGER,
    sho INTEGER,
    sv INTEGER,
    ipouts INTEGER,
    h INTEGER,
    er INTEGER,
    hr INTEGER,
    bb INTEGER,
    so INTEGER,
    baopp TEXT,
    era INTEGER,
    ibb INTEGER,
    wp INTEGER,
    hbp INTEGER,
    bk INTEGER,
    bfp INTEGER,
    gf INTEGER,
    r INTEGER,
    sh INTEGER,
    sf INTEGER,
    g_idp INTEGER
);

CREATE TABLE baseball_1.salary (
    year INTEGER,
    team_id TEXT,
    league_id TEXT,
    player_id TEXT,
    salary INTEGER
);

CREATE TABLE baseball_1.college (
    college_id TEXT,
    name_full TEXT,
    city TEXT,
    state TEXT,
    country TEXT
);

CREATE TABLE baseball_1.postseason (
    year INTEGER,
    round TEXT,
    team_id_winner TEXT,
    league_id_winner TEXT,
    team_id_loser TEXT,
    league_id_loser TEXT,
    wins INTEGER,
    losses INTEGER,
    ties INTEGER
);

CREATE TABLE baseball_1.team (
    year INTEGER,
    league_id TEXT,
    team_id TEXT,
    franchise_id TEXT,
    div_id TEXT,
    rank INTEGER,
    g INTEGER,
    ghome INTEGER,
    w INTEGER,
    l INTEGER,
    div_win TEXT,
    wc_win TEXT,
    lg_win TEXT,
    ws_win TEXT,
    r INTEGER,
    ab INTEGER,
    h INTEGER,
    double INTEGER,
    triple INTEGER,
    hr INTEGER,
    bb INTEGER,
    so INTEGER,
    sb INTEGER,
    cs INTEGER,
    hbp INTEGER,
    sf INTEGER,
    ra INTEGER,
    er INTEGER,
    era INTEGER,
    cg INTEGER,
    sho INTEGER,
    sv INTEGER,
    ipouts INTEGER,
    ha INTEGER,
    hra INTEGER,
    bba INTEGER,
    soa INTEGER,
    e INTEGER,
    dp INTEGER,
    fp INTEGER,
    name TEXT,
    park TEXT,
    attendance INTEGER,
    bpf INTEGER,
    ppf INTEGER,
    team_id_br TEXT,
    team_id_lahman45 TEXT,
    team_id_retro TEXT
);

CREATE TABLE baseball_1.team_franchise (
    franchise_id TEXT,
    franchise_name TEXT,
    active TEXT,
    na_assoc TEXT
);

CREATE TABLE baseball_1.team_half (
    year INTEGER,
    league_id TEXT,
    team_id TEXT,
    half INTEGER,
    div_id TEXT,
    div_win TEXT,
    rank INTEGER,
    g INTEGER,
    w INTEGER,
    l INTEGER
);

ALTER TABLE baseball_1.player ADD CONSTRAINT pk_player PRIMARY KEY (player_id);

ALTER TABLE baseball_1.team ADD CONSTRAINT pk_team PRIMARY KEY (team_id);

ALTER TABLE baseball_1.college ADD CONSTRAINT pk_college PRIMARY KEY (college_id);

ALTER TABLE baseball_1.park ADD CONSTRAINT pk_park PRIMARY KEY (park_id);

ALTER TABLE baseball_1.all_star ADD CONSTRAINT fk_all_star_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.appearances ADD CONSTRAINT fk_appearances_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.appearances ADD CONSTRAINT fk_appearances_team_id_to_team FOREIGN KEY (team_id) REFERENCES baseball_1.team(team_id);

ALTER TABLE baseball_1.manager_award ADD CONSTRAINT fk_manager_award_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.player_award ADD CONSTRAINT fk_player_award_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.player_award_vote ADD CONSTRAINT fk_player_award_vote_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.batting ADD CONSTRAINT fk_batting_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.batting_postseason ADD CONSTRAINT fk_batting_postseason_team_id_to_team FOREIGN KEY (team_id) REFERENCES baseball_1.team(team_id);

ALTER TABLE baseball_1.batting_postseason ADD CONSTRAINT fk_batting_postseason_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.player_college ADD CONSTRAINT fk_player_college_college_id_to_college FOREIGN KEY (college_id) REFERENCES baseball_1.college(college_id);

ALTER TABLE baseball_1.player_college ADD CONSTRAINT fk_player_college_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.fielding ADD CONSTRAINT fk_fielding_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.fielding_outfield ADD CONSTRAINT fk_fielding_outfield_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.fielding_postseason ADD CONSTRAINT fk_fielding_postseason_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.hall_of_fame ADD CONSTRAINT fk_hall_of_fame_player_id_to_player FOREIGN KEY (player_id) REFERENCES baseball_1.player(player_id);

ALTER TABLE baseball_1.home_game ADD CONSTRAINT fk_home_game_park_id_to_park FOREIGN KEY (park_id) REFERENCES baseball_1.park(park_id);

ALTER TABLE baseball_1.home_game ADD CONSTRAINT fk_home_game_team_id_to_team FOREIGN KEY (team_id) REFERENCES baseball_1.team(team_id);

ALTER TABLE baseball_1.manager ADD CONSTRAINT fk_manager_team_id_to_team FOREIGN KEY (team_id) REFERENCES baseball_1.team(team_id);

ALTER TABLE baseball_1.manager_half ADD CONSTRAINT fk_manager_half_team_id_to_team FOREIGN KEY (team_id) REFERENCES baseball_1.team(team_id);

