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
    public partial class FormSettings : Form
    {
        private User user;
        private UserDAO userDAO = new UserDAO();

        private FormCharacterSelect characterSelect;

        public FormSettings(User user, FormCharacterSelect characterSelect)
        {
            InitializeComponent();

            this.user = user;
            this.characterSelect = characterSelect;
            lblCurrentEmail.Text = user.Email;

        }

        private void btnUpdateEmail_Click(object sender, EventArgs e)
        {
            string newEmail = txtNewEmail.Text.Trim();

            // Validate input is not empty
            if (string.IsNullOrWhiteSpace(newEmail))
            {
                MessageBox.Show("Please enter a new email.");
                return;
            }
            // attempt to update email
            try
            {
                userDAO.UpdateEmail(user.Email, newEmail);

                user.Email = newEmail;
                lblCurrentEmail.Text = user.Email;
                txtNewEmail.Clear();

                MessageBox.Show("Email updated successfully.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not update email: " + ex.Message);
            }
        }

        private void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string newPassword = ctrlPassword1.password;
            string confirmPassword = ctrlPassword2.password;

            if (string.IsNullOrWhiteSpace(newPassword))
            {
                MessageBox.Show("Please enter a new password.");
                return;
            }

            if (newPassword != confirmPassword)
            {
                MessageBox.Show("Passwords do not match.");
                return;
            }

            try
            {
                userDAO.UpdatePassword(user.Email, newPassword);

                MessageBox.Show("Password updated successfully.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not update password: " + ex.Message);
            }
        }

        private void buttonDelete_Click(object sender, EventArgs e)
        {
            // Show a confirmation dialog before deleting the account
            DialogResult result = MessageBox.Show(
                "Are you sure you want to permanently delete your account?",
                "Delete Account",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Warning
            );
            // If the user clicks "No", exit the method
            if (result != DialogResult.Yes)
            {
                return;
            }
            // Attempt to delete the account
            try
            {
                userDAO.DeleteAccount(user.Email);

                MessageBox.Show("Account deleted successfully.");

                FormLogin formLogin = new FormLogin();
                formLogin.Show();

                characterSelect.Close();
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Could not delete account: " + ex.Message);
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
                        this.Close();
        }
    }
}
