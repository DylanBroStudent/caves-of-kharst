using CavesOfKharst.DataAccess;
using CavesOfKharst.Forms;
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

namespace CavesOfKharst.Controls
{
    public partial class CtrlCharacter : UserControl
    {

        private int characterId;
        private string characterName;
        private CharacterDAO characterDAO = new CharacterDAO();

        private User user;
        private FormLogin formLogin;

        public CtrlCharacter(int id, string name, User user, FormLogin formLogin)
        {
            InitializeComponent();

            characterId = id;
            characterName = name;
            this.user = user;
            this.formLogin = formLogin;

            lblName.Text = name;
        }


        private void buttonDelete_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show(
                "Delete this character?",
                "Confirm",
                MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            characterDAO.DeleteCharacter(characterId);

            this.Parent.Controls.Remove(this);
            this.Dispose();
        }

        private void buttonPlay_Click(object sender, EventArgs e)
        {
            try // Start the game with the selected character
            {
                CharacterDAO dao = new CharacterDAO();
                dao.PlayCharacter(characterId);

                FormGame game = new FormGame(characterId, characterName, user, formLogin, this.FindForm());
                game.Show();
                this.FindForm().Hide();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not start game: " + ex.Message);
            }
        }
    }
}
