
/* Generic interface for UI */

class UIInterface {
	public:

	virtual void Launch();
	virtual void EnablePlay(bool en);
	virtual void ChangePlayer(int player);
	virtual void PlayAtIndex(int player, int idx);
	virtual void SetScore(int player, int score);
	virtual void Exit();
};
