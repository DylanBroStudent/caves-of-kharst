namespace CavesOfKharst.Forms
{
    partial class FormSettings
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            btnBack = new Button();
            label1 = new Label();
            label2 = new Label();
            label3 = new Label();
            btnUpdatePassword = new Button();
            txtNewEmail = new TextBox();
            ctrlPassword1 = new CavesOfKharst.Controls.CtrlPassword();
            btnUpdateEmail = new Button();
            ctrlPassword2 = new CavesOfKharst.Controls.CtrlPassword();
            label4 = new Label();
            btnDelete = new Button();
            lblCurrentEmail = new Label();
            SuspendLayout();
            // 
            // btnBack
            // 
            btnBack.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnBack.BackColor = Color.FromArgb(255, 192, 192);
            btnBack.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnBack.Location = new Point(551, 12);
            btnBack.Name = "btnBack";
            btnBack.Size = new Size(119, 39);
            btnBack.TabIndex = 2;
            btnBack.Text = "Back";
            btnBack.UseVisualStyleBackColor = false;
            btnBack.Click += btnBack_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 24F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(12, 12);
            label1.Name = "label1";
            label1.Size = new Size(150, 45);
            label1.TabIndex = 0;
            label1.Text = "Settings:";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(60, 98);
            label2.Name = "label2";
            label2.Size = new Size(111, 30);
            label2.TabIndex = 3;
            label2.Text = "New Email";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label3.Location = new Point(24, 169);
            label3.Name = "label3";
            label3.Size = new Size(147, 30);
            label3.TabIndex = 6;
            label3.Text = "New Password";
            label3.TextAlign = ContentAlignment.MiddleRight;
            // 
            // btnUpdatePassword
            // 
            btnUpdatePassword.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnUpdatePassword.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnUpdatePassword.Location = new Point(475, 215);
            btnUpdatePassword.Name = "btnUpdatePassword";
            btnUpdatePassword.Size = new Size(195, 37);
            btnUpdatePassword.TabIndex = 10;
            btnUpdatePassword.Text = "Update Password";
            btnUpdatePassword.UseVisualStyleBackColor = true;
            btnUpdatePassword.Click += btnUpdatePassword_Click;
            // 
            // txtNewEmail
            // 
            txtNewEmail.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            txtNewEmail.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            txtNewEmail.Location = new Point(177, 98);
            txtNewEmail.Name = "txtNewEmail";
            txtNewEmail.Size = new Size(292, 35);
            txtNewEmail.TabIndex = 4;
            // 
            // ctrlPassword1
            // 
            ctrlPassword1.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            ctrlPassword1.Location = new Point(177, 169);
            ctrlPassword1.Name = "ctrlPassword1";
            ctrlPassword1.Size = new Size(292, 37);
            ctrlPassword1.TabIndex = 7;
            // 
            // btnUpdateEmail
            // 
            btnUpdateEmail.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnUpdateEmail.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnUpdateEmail.Location = new Point(475, 98);
            btnUpdateEmail.Name = "btnUpdateEmail";
            btnUpdateEmail.Size = new Size(195, 37);
            btnUpdateEmail.TabIndex = 5;
            btnUpdateEmail.Text = "Update Email";
            btnUpdateEmail.UseVisualStyleBackColor = true;
            btnUpdateEmail.Click += btnUpdateEmail_Click;
            // 
            // ctrlPassword2
            // 
            ctrlPassword2.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            ctrlPassword2.Location = new Point(177, 215);
            ctrlPassword2.Name = "ctrlPassword2";
            ctrlPassword2.Size = new Size(292, 37);
            ctrlPassword2.TabIndex = 9;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label4.Location = new Point(84, 215);
            label4.Name = "label4";
            label4.Size = new Size(87, 30);
            label4.TabIndex = 8;
            label4.Text = "Confirm";
            // 
            // btnDelete
            // 
            btnDelete.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnDelete.Font = new Font("Segoe UI", 24F, FontStyle.Bold, GraphicsUnit.Point, 0);
            btnDelete.Location = new Point(12, 290);
            btnDelete.Name = "btnDelete";
            btnDelete.Size = new Size(658, 59);
            btnDelete.TabIndex = 11;
            btnDelete.Text = "Delete Account";
            btnDelete.UseVisualStyleBackColor = true;
            btnDelete.Click += buttonDelete_Click;
            // 
            // lblCurrentEmail
            // 
            lblCurrentEmail.AutoSize = true;
            lblCurrentEmail.Font = new Font("Segoe UI", 24F, FontStyle.Bold, GraphicsUnit.Point, 0);
            lblCurrentEmail.Location = new Point(168, 12);
            lblCurrentEmail.Name = "lblCurrentEmail";
            lblCurrentEmail.Size = new Size(209, 45);
            lblCurrentEmail.TabIndex = 1;
            lblCurrentEmail.Text = "currentEmail";
            // 
            // FormSettings
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(684, 361);
            Controls.Add(lblCurrentEmail);
            Controls.Add(btnDelete);
            Controls.Add(label4);
            Controls.Add(ctrlPassword2);
            Controls.Add(btnUpdateEmail);
            Controls.Add(ctrlPassword1);
            Controls.Add(txtNewEmail);
            Controls.Add(btnUpdatePassword);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(btnBack);
            MinimumSize = new Size(700, 400);
            Name = "FormSettings";
            Text = "Settings";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button btnBack;
        private Label label1;
        private Label label2;
        private Label label3;
        private Button btnUpdatePassword;
        private TextBox txtNewEmail;
        private Controls.CtrlPassword ctrlPassword1;
        private Button btnUpdateEmail;
        private Controls.CtrlPassword ctrlPassword2;
        private Label label4;
        private Button btnDelete;
        private Label lblCurrentEmail;
    }
}