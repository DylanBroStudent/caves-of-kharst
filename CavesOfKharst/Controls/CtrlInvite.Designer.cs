namespace CavesOfKharst.Controls
{
    partial class CtrlInvite
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();
            lblInviter = new Label();
            btnAccept = new Button();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label1.Location = new Point(6, 7);
            label1.Name = "label1";
            label1.Size = new Size(65, 30);
            label1.TabIndex = 0;
            label1.Text = "From:";
            // 
            // lblInviter
            // 
            lblInviter.AutoSize = true;
            lblInviter.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            lblInviter.Location = new Point(77, 7);
            lblInviter.Name = "lblInviter";
            lblInviter.Size = new Size(71, 30);
            lblInviter.TabIndex = 1;
            lblInviter.Text = "Inviter";
            // 
            // btnAccept
            // 
            btnAccept.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnAccept.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnAccept.Location = new Point(260, 4);
            btnAccept.Name = "btnAccept";
            btnAccept.Size = new Size(114, 38);
            btnAccept.TabIndex = 2;
            btnAccept.Text = "Accept";
            btnAccept.UseVisualStyleBackColor = true;
            btnAccept.Click += btnAccept_Click;
            // 
            // CtrlInvite
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            Controls.Add(btnAccept);
            Controls.Add(lblInviter);
            Controls.Add(label1);
            Name = "CtrlInvite";
            Size = new Size(377, 45);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label lblInviter;
        private Button btnAccept;
    }
}
