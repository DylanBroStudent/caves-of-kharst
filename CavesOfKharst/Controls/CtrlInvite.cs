using CavesOfKharst.DataAccess;
using CavesOfKharst.Forms;
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
    public partial class CtrlInvite : UserControl
    {
        private int partyId;
        private int characterId;

        public CtrlInvite(string inviterName, int partyId, int characterId)
        {
            InitializeComponent();

            this.partyId = partyId;
            this.characterId = characterId;

            lblInviter.Text = inviterName;
        }

        private void btnAccept_Click(object sender, EventArgs e)
        {
            try
            {
                CharacterDAO dao = new CharacterDAO();
                dao.AddPlayerToParty(partyId, characterId);

                MessageBox.Show("You joined the party!");

                FormViewInvites form = this.FindForm() as FormViewInvites;

                if (form != null)
                {
                    form.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not accept invitation: " + ex.Message);
            }
        }
    }
}