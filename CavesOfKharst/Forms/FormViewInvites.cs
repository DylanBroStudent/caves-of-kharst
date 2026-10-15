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
    public partial class FormViewInvites : Form
    {
        private int characterId;

        public FormViewInvites(int characterId)
        {
            InitializeComponent();
            this.characterId = characterId;
            LoadInvites();
        }

        private void LoadInvites()
        {
            CharacterDAO dao = new CharacterDAO();
            DataTable invites = dao.GetPartyInvites(characterId);

            listInvites.Controls.Clear();

            foreach (DataRow row in invites.Rows)
            {
                CtrlInvite invite = new CtrlInvite(
                    row["inviter_name"].ToString(),
                    Convert.ToInt32(row["party_id"]),
                    characterId
                );
                listInvites.Controls.Add(invite);
            }
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadInvites();
        }
    }
}
