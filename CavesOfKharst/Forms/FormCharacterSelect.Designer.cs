namespace CavesOfKharst.Forms
{
    partial class FormCharacterSelect
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
            label1 = new Label();
            label2 = new Label();
            lblUser = new Label();
            btnLogout = new Button();
            SuspendLayout();
            // 
            // label1
            // 
            label1.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 27.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(12, 9);
            label1.Name = "label1";
            label1.Size = new Size(288, 50);
            label1.TabIndex = 4;
            label1.Text = "Caves of Kharst";
            // 
            // label2
            // 
            label2.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(12, 89);
            label2.Name = "label2";
            label2.Size = new Size(111, 30);
            label2.TabIndex = 5;
            label2.Text = "Characters";
            // 
            // lblUser
            // 
            lblUser.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            lblUser.AutoSize = true;
            lblUser.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            lblUser.Location = new Point(12, 59);
            lblUser.Name = "lblUser";
            lblUser.Size = new Size(136, 30);
            lblUser.TabIndex = 6;
            lblUser.Text = "Logged in as:";
            // 
            // btnLogout
            // 
            btnLogout.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnLogout.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnLogout.Location = new Point(523, 12);
            btnLogout.Name = "btnLogout";
            btnLogout.Size = new Size(104, 38);
            btnLogout.TabIndex = 7;
            btnLogout.Text = "Logout";
            btnLogout.UseVisualStyleBackColor = true;
            btnLogout.Click += btnLogout_Click;
            // 
            // FormCharacterSelect
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            CancelButton = btnLogout;
            ClientSize = new Size(639, 578);
            Controls.Add(btnLogout);
            Controls.Add(lblUser);
            Controls.Add(label2);
            Controls.Add(label1);
            Name = "FormCharacterSelect";
            Text = "FormCharacterSelect";
            Load += FormCharacterSelect_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label label2;
        private Label lblUser;
        private Button btnLogout;
    }
}