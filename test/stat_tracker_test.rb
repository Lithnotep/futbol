require './test/test_helper'
require './lib/stat_tracker'
require 'mocha/minitest'

class StatTrackerTest < Minitest::Test

  def setup
    game_path = './data/games_fixture.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams_fixture.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_has_attributes
    assert_instance_of LeagueStatistics, @stat_tracker.league_statistics
    assert_instance_of TeamStatistics, @stat_tracker.team_statistics
    assert_instance_of GameStatistics, @stat_tracker.game_statistics
    assert_instance_of SeasonStatistics, @stat_tracker.season_statistics
  end

  def test_highest_total_score
    assert_equal 6, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_can_calculate_percentage_of_home_wins
    assert_equal 0.63, @stat_tracker.percentage_home_wins
  end
  #
  def test_it_can_calculate_percentage_of_visitor_game_wins
    assert_equal 0.25, @stat_tracker.percentage_visitor_wins
  end
  #
  def test_it_can_calculate_percenatage_ties
    assert_equal 0.13, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    assert_equal ({"20122013"=>12, "20132014"=>3, "20172018"=>3, "20162017"=>3, "20152016"=>1, "20142015"=>5}), @stat_tracker.count_of_games_by_season
  end

  def test_average_number_of_goals_per_game
    assert_equal 4.11,@stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    assert_equal ({"20122013"=>4.0, "20132014"=>4.0, "20172018"=>3.67, "20162017"=>4.33, "20152016"=>4.0, "20142015"=>4.6}), @stat_tracker.average_goals_by_season
  end

  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_best_offense
    @stat_tracker.league_statistics.stubs(:average_goals_by_team).returns({"1" => 1, "6" => 2.5, "3" => 2.2})
    assert_equal "FC Dallas", @stat_tracker.best_offense
  end

  def test_worst_offense
    @stat_tracker.league_statistics.stubs(:average_goals_by_team).returns({"1" => 2.5, "6" => 2, "3" => 1.3})
    expected = "Houston Dynamo"
    assert_equal expected, @stat_tracker.worst_offense
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_lowest_scoring_visitor
    assert_equal "Sporting Kansas City", @stat_tracker.lowest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Real Salt Lake", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team
    assert_equal "Seattle Sounders FC", @stat_tracker.lowest_scoring_home_team
  end

  def test_team_info
    expected1 = {"team_id" => "1", "franchise_id" => "23", "team_name" => "Atlanta United", "abbreviation" => "ATL", "link" => "/api/v1/teams/1"}
    expected2 = {"team_id" => "4", "franchise_id" => "16", "team_name" => "Chicago Fire", "abbreviation" => "CHI", "link"=> "/api/v1/teams/4"}

    assert_equal expected1, @stat_tracker.team_info("1")
    assert_equal expected2, @stat_tracker.team_info("4")
  end

  def test_best_season
      assert_equal "20132014", @stat_tracker.best_season("24")
  end

  def test_worst_season
    assert_equal "20142015", @stat_tracker.worst_season("24")
  end

  def test_average_win_percentage
    assert_equal 0.0, @stat_tracker.average_win_percentage("3")
    assert_equal 1.0, @stat_tracker.average_win_percentage("6")
    assert_equal 0.5, @stat_tracker.average_win_percentage("9")
    assert_equal 0.25, @stat_tracker.average_win_percentage("8")
  end

  def test_most_goals_scored
    assert_equal 3, @stat_tracker.most_goals_scored("6")
    assert_equal 2, @stat_tracker.most_goals_scored("3")
    assert_equal 3, @stat_tracker.most_goals_scored("8")
    assert_equal 4, @stat_tracker.most_goals_scored("9")
  end

  def test_fewest_goals_scored
    assert_equal 2, @stat_tracker.fewest_goals_scored("6")
    assert_equal 1, @stat_tracker.fewest_goals_scored("3")
    assert_equal 1, @stat_tracker.fewest_goals_scored("8")
    assert_equal 1, @stat_tracker.fewest_goals_scored("9")
  end

  def test_favorite_opponent
    assert_equal "Chicago Fire", @stat_tracker.favorite_opponent("24")
    assert_equal "Philadelphia Union", @stat_tracker.favorite_opponent("22")
  end

  def test_rival
    assert_equal "Real Salt Lake", @stat_tracker.rival("22")
    assert_equal "FC Dallas", @stat_tracker.rival("3")
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20122013")
  end

  def test_losingest_coach
    assert_equal "John Tortorella", @stat_tracker.worst_coach("20122013")
  end

  def test_most_least_tackles
    assert_equal "Houston Dynamo", @stat_tracker.most_tackles("20122013")
    assert_equal "FC Dallas", @stat_tracker.fewest_tackles("20122013")
  end

  def test_most_accurate_team
    assert_equal "FC Dallas", @stat_tracker.most_accurate_team("20122013")
  end

  def test_least_accurate_team
    assert_equal "Houston Dynamo", @stat_tracker.least_accurate_team("20122013")
  end

end
