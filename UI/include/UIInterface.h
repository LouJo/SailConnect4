
/* Generic interface for UI */

class UIInterface {
	public:

	virtual void Launch() = 0;
	virtual void EnablePlay(bool en) = 0;
	virtual void ChangePlayer(int player) = 0;
	virtual bool PlayAtIndex(int player, int idx) = 0;
	virtual void SetScore(int player, int score) = 0;
	virtual void ResetBoard() = 0;
	virtual void Exit() = 0;
	virtual void Loop() = 0;
};
