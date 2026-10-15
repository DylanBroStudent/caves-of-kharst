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
        private bool isReady = false;

        private User user;
        private FormLogin formLogin;
        private Form characterSelect;
        
        private int tileSize = 63;
        private bool boardCreated = false;

        // Dictionary to hold the entity images
        private Dictionary<string, Image> entityImages  = new Dictionary<string, Image>();
        // Dictionary to hold entities
        private Dictionary<long, PictureBox> boardEntities = new Dictionary<long, PictureBox>();

        private int kickCharacterId1;
        private int kickCharacterId2;
        private int kickCharacterId3;
        private int kickCharacterId4;

        public FormGame(int id, string name, User user, FormLogin formLogin, Form characterSelect)
        {
            InitializeComponent();

            characterId     = id;
            characterName   = name;
            this.user       = user;
            this.formLogin  = formLogin;
            this.characterSelect = characterSelect;

            this.Text = $"Caves of Kharst - {characterName}";

            LoadParty();
            LoadEntityImages();
            SetupInventoryGrid();
            LoadInventory();
        }

        private void LoadEntityImages()
        {
            string folder = Path.Combine(Application.StartupPath, "Images");

            // Load images for entities

            // Items
            entityImages["Coin"]                   = Image.FromFile(Path.Combine(folder, "coin.png"));
            entityImages["Brilliant Teleport Gem"] = Image.FromFile(Path.Combine(folder, "gem2.png"));
            entityImages["Brilliant Fireball Gem"] = Image.FromFile(Path.Combine(folder, "gem1.png"));
            entityImages["Radiant Fireball Gem"]   = Image.FromFile(Path.Combine(folder, "gem1.png"));

            // Players
            entityImages["wizard"] = Image.FromFile(Path.Combine(folder, "wizard.png"));

            //NPCs
            entityImages["rat"] = Image.FromFile(Path.Combine(folder, "rat.png"));

            // Structures
            entityImages["rock"]     = Image.FromFile(Path.Combine(folder, "rock.png"));
            entityImages["doorway"]  = Image.FromFile(Path.Combine(folder, "doorway.png"));
            entityImages["shop"]     = Image.FromFile(Path.Combine(folder, "shop.png"));
            entityImages["stash"]    = Image.FromFile(Path.Combine(folder, "stash.png"));
            entityImages["wardrobe"] = Image.FromFile(Path.Combine(folder, "wardrobe.png"));
        }

        private void SetupInventoryGrid()
        {
            gridInventory.Controls.Clear();
            gridInventory.ColumnCount = 8;
            gridInventory.RowCount = 1;

            for (int i = 0; i < 8; i++)
            {
                PictureBox picture  = new PictureBox();

                // Add click event handler for dropping items
                picture.Click += (sender, e) =>
                {
                    if (picture.Tag != null)
                        DropItem(Convert.ToInt32(picture.Tag));
                };

                picture.Dock        = DockStyle.Fill;
                picture.SizeMode    = PictureBoxSizeMode.Zoom;
                picture.BackColor   = Color.FromArgb(20, 35, 65);

                gridInventory.Controls.Add(picture, i, 0);

            }
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

                // Update the ready button
                if (playerId == characterId)
                {
                    bool gameStarted = party.Rows[i]["game_id"] != DBNull.Value;

                    if (gameStarted)
                    {
                        
                        btnReady.BackColor = Color.FromArgb(192, 255, 192);
                        btnReady.Text = "Game Starting...";
                        btnReady.Enabled = false;
                    }
                    else
                    {
                        isReady = Convert.ToBoolean(party.Rows[i]["ready"]);
                        btnReady.BackColor = isReady ? Color.FromArgb(192, 255, 192): Color.FromArgb(255, 192, 192);
                        btnReady.Text = isReady ? "Ready!" : "Ready Up";
                        btnReady.Enabled = true;
                    }
                }

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
                    kickButton  = btnKickPlayer1;
                }
                else if (i == 1)
                {
                    playerLabel = lblPlayer2Name;
                    kickButton  = btnKickPlayer2;
                }
                else if (i == 2)
                {
                    playerLabel = lblPlayer3Name;
                    kickButton  = btnKickPlayer3;
                }
                else if (i == 3)
                {
                    playerLabel = lblPlayer4Name;
                    kickButton  = btnKickPlayer4;
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
        private void LoadBoard()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable room = dao.GetRoom(characterId);

            if (!boardCreated)
            {
                foreach (DataRow row in room.Rows)
                {
                    Panel tile      = new Panel();
                    tile.Size       = new Size(tileSize, tileSize);
                    tile.Location   = new Point(
                        Convert.ToInt32(row["position_x"]) * tileSize,
                        Convert.ToInt32(row["position_y"]) * tileSize);

                    tile.BackColor = Color.FromArgb(10, 20, 50);
                    tile.BorderStyle = BorderStyle.FixedSingle;
                    panelGameBoard.Controls.Add(tile);
                }

                boardCreated = true;
            }
            // Create a list to track current entities
            List<long> currentEntities = new List<long>();
            
            foreach (DataRow row in room.Rows)
            {
                if (row["entity_instance_id"] == DBNull.Value)
                    continue;

                long id = Convert.ToInt64(row["entity_instance_id"]);
                currentEntities.Add(id);

                string entityName = null;

                if (row["player_character_id"] != DBNull.Value)
                    entityName = "wizard";

                else if (row["item_name"] != DBNull.Value)
                    entityName = row["item_name"].ToString();

                else if (row["structure_name"] != DBNull.Value)
                    entityName = row["structure_name"].ToString();

                else if (row["npc_id"] != DBNull.Value)
                    entityName = row["npc_name"].ToString();

                if (entityName == null || !entityImages.ContainsKey(entityName))
                    continue;

                // Create an image only for a new entity
                if (!boardEntities.ContainsKey(id))
                {
                    PictureBox picture  = new PictureBox();
                    picture.Size        = new Size(tileSize, tileSize);
                    picture.SizeMode    = PictureBoxSizeMode.Zoom;
                    picture.BackColor   = Color.FromArgb(10, 20, 50);
                    picture.BorderStyle = BorderStyle.FixedSingle;
                    picture.Image       = entityImages[entityName];
                    
                    boardEntities[id] = picture;
                    panelGameBoard.Controls.Add(picture);
                    picture.BringToFront();
                }

                // Update the existing entity's position
                boardEntities[id].Location = new Point(
                    Convert.ToInt32(row["position_x"]) * tileSize,
                    Convert.ToInt32(row["position_y"]) * tileSize);
            }

            // Remove entities that no longer exist
            List<long> removedEntities = new List<long>();

            foreach (long id in boardEntities.Keys)
            {
                if (!currentEntities.Contains(id))
                    removedEntities.Add(id);
            }

            foreach (long id in removedEntities)
            {
                panelGameBoard.Controls.Remove(boardEntities[id]);
                boardEntities[id].Dispose();
                boardEntities.Remove(id);
            }
        }
        private void LoadInventory()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable inventory = dao.GetInventory(characterId);

            for (int i = 0; i < 8; i++)
            {
                PictureBox picture = (PictureBox)gridInventory.GetControlFromPosition(i, 0);
                picture.Image = null;
                picture.Tag = null;
            }

            foreach (DataRow row in inventory.Rows)
            {
                int slotNo = Convert.ToInt32(row["slot_no"]);
                string itemName = row["item_name"].ToString();

                if (slotNo < 1 || slotNo > 8)
                    continue;

                PictureBox picture = (PictureBox)gridInventory.GetControlFromPosition(slotNo - 1, 0);

                if (entityImages.ContainsKey(itemName))
                    picture.Image = entityImages[itemName];

                picture.Tag = slotNo;
            }
        }
        

        private void btnLogout_Click(object sender, EventArgs e)
        {
            CloseGame();
        }

        private void btnReady_Click(object sender, EventArgs e)
        {
            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.ToggleReady(characterId);

                // Update button
                isReady = !isReady;
                btnReady.UseVisualStyleBackColor = false;
                btnReady.BackColor = isReady ? Color.FromArgb(192, 255, 192) : Color.FromArgb(255, 192, 192);
                btnReady.Text = isReady ? "Ready!" : "Ready Up";

                // Refresh the party display
                LoadParty();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not change ready status: " + ex.Message);
            }
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
            PickUpItem();
        }
        private void PickUpItem()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable room = dao.GetRoom(characterId);

            int playerX = -1;
            int playerY = -1;

            // Find the player's position
            foreach (DataRow row in room.Rows)
            {
                if (row["player_character_id"] != DBNull.Value &&
                    Convert.ToInt32(row["player_character_id"]) == characterId)
                {
                    playerX = Convert.ToInt32(row["position_x"]);
                    playerY = Convert.ToInt32(row["position_y"]);
                    break;
                }
            }

            // Find the first item on the player's tile
            foreach (DataRow row in room.Rows)
            {
                if (row["item_name"] != DBNull.Value &&
                    Convert.ToInt32(row["position_x"]) == playerX &&
                    Convert.ToInt32(row["position_y"]) == playerY)
                {
                    dao.PickUpItem(
                        characterId,
                        Convert.ToInt64(row["entity_instance_id"]));

                    LoadBoard();
                    LoadInventory();
                    return;
                }
            }
        }
        private void DropItem(int slotNo)
        {
            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.DropItem(characterId, slotNo);

                LoadInventory();
                LoadBoard();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not drop item: " + ex.Message);
            }
        }

        private void MovePlayer(string direction)
        {
            CharacterDAO dao = new CharacterDAO();

            string result = dao.MoveCharacter(characterId, direction);

            if (result == "Moved")
                LoadBoard();
        }
        private void FormGame_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode      == Keys.W || e.KeyCode == Keys.Up)
                MovePlayer("w");
            else if (e.KeyCode == Keys.A || e.KeyCode == Keys.Left)
                MovePlayer("a");
            else if (e.KeyCode == Keys.S || e.KeyCode == Keys.Down)
                MovePlayer("s");
            else if (e.KeyCode == Keys.D || e.KeyCode == Keys.Right)
                MovePlayer("d");
            else if (e.KeyCode == Keys.E)
                PickUpItem();
        }
        private void btnMoveUp_Click(object sender, EventArgs e)
        {
            MovePlayer("w");
        }

        private void btnMoveLeft_Click(object sender, EventArgs e)
        {
            MovePlayer("a");
        }

        private void btnMoveDown_Click(object sender, EventArgs e)
        {
            MovePlayer("s");
        }

        private void btnMoveRight_Click(object sender, EventArgs e)
        {
            MovePlayer("d");
        }

        private void btnSend_Click(object sender, EventArgs e)
        {
            string contents = textMessage.Text.Trim();

            if (contents == "")
                return;

            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.SendMessage(characterId, contents);

                textMessage.Clear();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not send message: " + ex.Message);
            }
        }

        private void LoadMessages()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable messages = dao.GetMessages(characterId);

            textChat.Clear();

            foreach (DataRow row in messages.Rows)
            {
                string sender = row["sender_name"].ToString();
                string contents = row["contents"].ToString();

                textChat.AppendText(
                    sender + ": " + contents + Environment.NewLine);
            }

            // Scroll to the latest message
            textChat.SelectionStart =
                textChat.Text.Length;

            textChat.ScrollToCaret();
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
            LoadMessages();
            LoadBoard();
        }
    }
}
