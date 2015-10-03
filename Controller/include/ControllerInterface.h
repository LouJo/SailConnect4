
/* Generic interface for Controller */

#include <string>

class ControllerInterface {
	public:

	// types definitions for game config

	typedef enum { TypeHuman, TypeIA } PlayerType_t;

	struct ConfigPlayer {
		std::string name;
		int force;
		PlayerType_t type;
	};

	struct Config {
		ConfigPlayer configPlayer[2];
		int rows, columns;
	};

	// methods for UI calls

	virtual void NewGame();
	virtual void ResetScores();
	virtual void PlayAtCol(int col);

	virtual void ConfigSet(const Config &config);
	virtual void ExitGame();
};
