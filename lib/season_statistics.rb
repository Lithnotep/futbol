require './lib/stat_tracker'
require 'pry'

class SeasonStatistics
attr_reader :stat_tracker, :game_collection, :game_teams_collection, :teams_collection

  def initialize(game_collection, game_teams_collection, teams_collection)
    @game_collection = game_collection
    @game_teams_collection = game_teams_collection
    @teams_collection = teams_collection
  end

  def current_season_games(season)
    current_games = @game_collection.map do |game|
     if game.season == season
       game.game_id
     end
   end
   current_games.compact
  end

  def teams_hash(season)
    teams = Hash.new(0)
    season_teams = current_season_game_teams(season).map do |game|
      game.team_id
      end
    @teams_collection.each do |team|
        if season_teams.include?(team.id)
          teams[team.id] = 0
        end
      end
    teams
  end

  def coaches_hash(season)
    coaches = Hash.new(0)
    season_coaches = current_season_game_teams(season).map do |game|
      game.head_coach
      end
    @game_teams_collection.each do |team|
        if season_coaches.include?(team.head_coach)
          coaches[team.head_coach] = 0
        end
      end
    coaches
  end

  def current_season_game_teams(season)
    current = @game_teams_collection.find_all do |game|
    current_season_games(season).include?(game.game_id)
    end
  end

  def coach_win_loss_results(season, high_low)
    coaches_win = coaches_hash(season)
    coaches_lose = coaches_hash(season)
    current_season_game_teams(season).each do |game|
      if game.result == "WIN"
        coaches_win[game.head_coach] += 1
      elsif game.result == "LOSS"
        coaches_lose[game.head_coach] += 1
      end
    end
    if high_low == "high"
    winning_coach = coaches_win.max_by {|coach| coach[1]}
    winning_coach[0]
    elsif high_low == "low"
    losing_coach = coaches_lose.max_by {|coach| coach[1]}
    losing_coach[0]
    end
  end

  def most_least_tackles(season, high_low)
    teams = teams_hash(season)
    current_season_game_teams(season).each do |game|
      teams[game.team_id] += game.tackles
    end
    if high_low == "high"
      most_tackles = teams.max_by {|team| team[1]}
      highest_team = @teams_collection.find {|team| team.id == most_tackles[0]}
      highest_team.team_name
    elsif high_low == "low"
      fewest_tackles = teams.min_by {|team| team[1]}
      lowest_team = @teams_collection.find {|team| team.id == fewest_tackles[0]}
      lowest_team.team_name
    end
  end





end