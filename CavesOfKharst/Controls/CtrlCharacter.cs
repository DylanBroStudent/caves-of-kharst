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

namespace CavesOfKharst.Controls
{
    public partial class CtrlCharacter : UserControl
    {
        private int characterId;
        private CharacterDAO characterDAO = new CharacterDAO();

        public CtrlCharacter(int id, string name)
        {
            InitializeComponent();

            characterId = id;
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
    }
}
