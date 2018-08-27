#include <eosiolib/eosio.hpp>
#include <vector>

class tic_tac_toe : public eosio::contract {
public:
  tic_tac_toe(account_name self) : contract(self) {
  }

  struct game {
    static const uint16_t board_width = 3;
    static const uint16_t board_height = board_width;

    game() {
      initialize_board();
    }

    account_name challenger;
    account_name host;
    account_name turn;             // = account name of host/ challenger
    account_name winner = N(none); // = none/ draw/ name of host/ name of challenger
    std::vector<uint8_t> board;

    // Initialize board with empty cell
    void initialize_board() {
      board = std::vector<uint8_t>(board_width * board_height, 0);
    }

    // Reset game
    void reset_game() {
      initialize_board();
      turn = host;
      winner = N(none);
    }

    auto primary_key() const {
      return challenger;
    }

    EOSLIB_SERIALIZE(game, (challenger)(host)(turn)(winner)(board))
  };

  typedef eosio::multi_index<N(games), game> games;

  struct create {
    account_name challenger;
    account_name host;
  };

  struct restart {
    account_name challenger;
    account_name host;
    account_name by;
  };

  struct close {
    account_name challenger;
    account_name host;
  };

  struct move {
    account_name challenger;
    account_name host;
    account_name by; // the account who wants to make the move
    uint16_t row;
    uint16_t column;
  };

  void create(const account_name &challenger, const account_name &host);
  void restart(const account_name &challenger, const account_name &host, const account_name &by);
  void close(const account_name &challenger, const account_name &host);
  void move(const account_name &challenger, const account_name &host, const account_name &by, const uint16_t &row, const uint16_t &column);
};
