using CavesOfKharst.Classes;
using CavesOfKharst.Controls;
using CavesOfKharst.DataAccess;
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
    public partial class FormCharacterSelect : Form
    {
        // Data Access Object for characters
        private CharacterDAO characterDAO = new CharacterDAO();

        private User user;
        private FormLogin formLogin;

        public FormCharacterSelect(User user, FormLogin formLogin)
        {
            InitializeComponent();


            lblUser.Text = $"Logged in as: {user.Email}";
            this.user = user;
            this.formLogin = formLogin;

        }

        private void btnLogout_Click(object sender, EventArgs e)
        {
            formLogin.Show();
            this.Close();
        }

        private void FormCharacterSelect_Load(object sender, EventArgs e)
        {
            LoadCharacters();
        }

        private void LoadCharacters()
        {
            try
            {
                listCharacters.Controls.Clear();
                DataTable characters = characterDAO.GetCharacters(user.Id);

                foreach (DataRow row in characters.Rows)
                {
                    CtrlCharacter character = new CtrlCharacter(
                        Convert.ToInt32(row["player_character_id"]),
                        row["name"].ToString());

                    listCharacters.Controls.Add(character);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not load characters: " + ex.Message);
            }
        }

        private void btnNewCharacter_Click(object sender, EventArgs e)
        {
            // Open the character creation form
            using (FormCharacterCreate form = new FormCharacterCreate(user.Id))
            {
                if (form.ShowDialog(this) == DialogResult.OK)
                {
                    LoadCharacters();
                }
            }
        }

        private void btnSettings_Click(object sender, EventArgs e)
        {
            FormSettings settings = new FormSettings(user, this);
            settings.ShowDialog();
        }
    }
}
