#include <string>

/* Generic interface for Controller */

class ControllerInterface {
	public:
	typedef enum { TypeHuman, TypeIA } PlayerType_t;

	struct ConfigPlayer {
		std::string name;
		int force;
		PlayerType_t type;
	};

	virtual void NewGame();
	virtual void ResetScores();
	virtual void ExitGame();
	virtual void PlayAtCol(int col);

	virtual void ConfigSetPlayer(int player, const ConfigPlayer &config);
};
