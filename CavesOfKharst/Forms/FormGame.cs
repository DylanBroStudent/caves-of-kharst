using CavesOfKharst.DataAccess;
using CavesOfKharst.Classes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CavesOfKharst.Forms
{
    public partial class FormGame : Form
    {
        private int characterId;
        private string characterName;
        private bool loggingOut = false;

        private User user;
        private FormLogin formLogin;
        private Form characterSelect;

        private int kickCharacterId1;
        private int kickCharacterId2;
        private int kickCharacterId3;
        private int kickCharacterId4;

        public FormGame(int id, string name, User user, FormLogin formLogin, Form characterSelect)
        {
            InitializeComponent();

            characterId = id;
            characterName = name;
            this.user = user;
            this.formLogin = formLogin;
            this.characterSelect = characterSelect;

            this.Text = $"Caves of Kharst - {characterName}";

            LoadParty();
        }
        private void CloseGame()
        {
            loggingOut = true;

            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.LogoutCharacter(characterId);

                refreshTimer.Stop();
                characterSelect.Show();
                this.Close();
            }
            catch (Exception ex)
            {
                loggingOut = false;
                MessageBox.Show("Could not leave game: " + ex.Message);
            }
        }

        private void LoadParty()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable party = dao.GetParty(characterId);

            // Clear player names
            lblPlayer1Name.Text = "";
            lblPlayer2Name.Text = "";
            lblPlayer3Name.Text = "";
            lblPlayer4Name.Text = "";
            // Clear player scores
            lblPlayer1Score.Text = "";
            lblPlayer2Score.Text = "";
            lblPlayer3Score.Text = "";
            lblPlayer4Score.Text = "";

            // Clear character IDs
            kickCharacterId1 = 0;
            kickCharacterId2 = 0;
            kickCharacterId3 = 0;
            kickCharacterId4 = 0;

            // Hide kick buttons
            btnKickPlayer1.Visible = false;
            btnKickPlayer2.Visible = false;
            btnKickPlayer3.Visible = false;
            btnKickPlayer4.Visible = false;

            // Stop if there is no party data
            if (party.Rows.Count == 0)
                return;

            // Find the party leader
            int leaderId = Convert.ToInt32(
                party.Rows[0]["leader_character_id"]);

            bool isLeader = leaderId == characterId;

            // Fill the player slots
            for (int i = 0; i < party.Rows.Count && i < 4; i++)
            {
                int playerId = Convert.ToInt32(
                    party.Rows[i]["player_character_id"]);

                string name = party.Rows[i]["player_name"].ToString();

                // Store the character ID for this slot
                if (i == 0)
                    kickCharacterId1 = playerId;
                else if (i == 1)
                    kickCharacterId2 = playerId;
                else if (i == 2)
                    kickCharacterId3 = playerId;
                else if (i == 3)
                    kickCharacterId4 = playerId;

                // Choose the label and button for the slot
                Label playerLabel = null;
                Button kickButton = null;

                if (i == 0)
                {
                    playerLabel = lblPlayer1Name;
                    kickButton = btnKickPlayer1;
                }
                else if (i == 1)
                {
                    playerLabel = lblPlayer2Name;
                    kickButton = btnKickPlayer2;
                }
                else if (i == 2)
                {
                    playerLabel = lblPlayer3Name;
                    kickButton = btnKickPlayer3;
                }
                else if (i == 3)
                {
                    playerLabel = lblPlayer4Name;
                    kickButton = btnKickPlayer4;
                }

                playerLabel.Text = name;

                // Set button text and visibility
                if (playerId == characterId)
                {
                    kickButton.Text = "Leave";
                    kickButton.Visible = true;
                }
                else if (isLeader)
                {
                    kickButton.Text = "Kick";
                    kickButton.Visible = true;
                }
            }
        }


        private void btnLogout_Click(object sender, EventArgs e)
        {
            CloseGame();
        }

        private void btnReady_Click(object sender, EventArgs e)
        {

        }

        private void KickPlayer(int targetCharacterId, Button button)
        {
            if (targetCharacterId == 0)
                return;

            bool isLeaving = targetCharacterId == characterId;

            if (isLeaving)
            {
                DialogResult result = MessageBox.Show(
                    "Are you sure you want to leave the party?",
                    "Leave Party",
                    MessageBoxButtons.YesNo);

                if (result != DialogResult.Yes)
                    return;
            }
            else
            {
                DialogResult result = MessageBox.Show(
                    "Are you sure you want to kick this player?",
                    "Kick Player",
                    MessageBoxButtons.YesNo);

                if (result != DialogResult.Yes)
                    return;
            }

            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.RemovePlayerFromParty(targetCharacterId);

                LoadParty();

            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not remove player: " + ex.Message);
            }
        }

        private void btnKickPlayer1_Click(object sender, EventArgs e)
        {
            KickPlayer(kickCharacterId1, btnKickPlayer1);
        }

        private void btnKickPlayer2_Click(object sender, EventArgs e)
        {
            KickPlayer(kickCharacterId2, btnKickPlayer2);
        }

        private void btnKickPlayer3_Click(object sender, EventArgs e)
        {
            KickPlayer(kickCharacterId3, btnKickPlayer3);
        }

        private void btnKickPlayer4_Click(object sender, EventArgs e)
        {
            KickPlayer(kickCharacterId4, btnKickPlayer4);
        }
        private void btnViewInvites_Click(object sender, EventArgs e)
        {
            FormViewInvites form = new FormViewInvites(characterId);
            form.ShowDialog();
        }

        private void btnInvite_Click(object sender, EventArgs e)
        {
            FormSendInvite form = new FormSendInvite(characterId);
            form.ShowDialog();
        }

        private void btnEnterDoor_Click(object sender, EventArgs e)
        {

        }

        private void btnPickup_Click(object sender, EventArgs e)
        {

        }

        private void btnMoveUp_Click(object sender, EventArgs e)
        {

        }

        private void btnMoveLeft_Click(object sender, EventArgs e)
        {

        }

        private void btnMoveDown_Click(object sender, EventArgs e)
        {

        }

        private void btnMoveRight_Click(object sender, EventArgs e)
        {

        }

        private void btnSend_Click(object sender, EventArgs e)
        {

        }
        private void FormGame_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (loggingOut)
                return;

            try
            {
                loggingOut = true;

                CharacterDAO dao = new CharacterDAO();
                dao.LogoutCharacter(characterId);

                refreshTimer.Stop();
                characterSelect.Show();
            }
            catch (Exception ex)
            {
                loggingOut = false;
                e.Cancel = true;

                MessageBox.Show("Could not leave game: " + ex.Message);
            }
        }

        private void refreshTimer_Tick(object sender, EventArgs e)
        {
            LoadParty();
        }
    }
}
