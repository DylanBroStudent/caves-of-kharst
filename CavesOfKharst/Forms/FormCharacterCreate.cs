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
    public partial class FormCharacterCreate : Form
    {
        private int userAccountId;
        private CharacterDAO characterDAO = new CharacterDAO();

        // Constructor
        public FormCharacterCreate(int userAccountId)
        {
            InitializeComponent();
            this.userAccountId = userAccountId;
        }

        private void btnSubmit_Click(object sender, EventArgs e)
        {
            string name = txtCharacterName.Text.Trim();

            // Validate character name
            if (string.IsNullOrWhiteSpace(name))
            {
                MessageBox.Show("Please enter a character name.");
                return;
            }
            // Attempt to create the character
            try
            {
                // Call the CreateCharacter method from CharacterDAO
                if (characterDAO.CreateCharacter(name, userAccountId))
                {
                    MessageBox.Show("Character created successfully.");
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                }
                else // If the character name is already taken, show a message
                {
                    MessageBox.Show("That character name is already taken.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not create character: " + ex.Message);
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }
}
