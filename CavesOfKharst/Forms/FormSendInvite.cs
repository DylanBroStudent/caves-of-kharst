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
    public partial class FormSendInvite : Form
    {
        private int characterId;



        public FormSendInvite(int characterId)
        {
            InitializeComponent();
            this.characterId = characterId;
        }

        private void btnSendInvite_Click(object sender, EventArgs e)
        {
            string characterName = textSendInvite.Text.Trim();

            if (characterName == "")
            {
                MessageBox.Show("Please enter a character name.");
                return;
            }
            // Use CharacterDAO to find the character by name
            CharacterDAO dao = new CharacterDAO();
            int inviteeCharacterId = dao.FindCharacterByName(characterName);

            DataTable party = dao.GetParty(characterId);

            if (party.Rows.Count == 0)
            {
                MessageBox.Show("Your character is not in a party.");
                return;
            }

            int partyId = Convert.ToInt32(party.Rows[0]["party_id"]);

            // Check if the character was found
            if (inviteeCharacterId == -1)
            {
                MessageBox.Show("Character not found.");
                return;
            }

            // Send the invite to the character
            try
            {
                dao.SendPartyInvite(partyId, characterId, inviteeCharacterId);

                MessageBox.Show("Invite sent to: " + characterName);
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not send invitation: " + ex.Message);
            }

        }
    }
}
