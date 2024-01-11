org 100h

jmp start       ; jump ke deklarasi data

        psn :    db      "++++++++++++++++++++++++++++++++++++++++++++++++++",0dh,0ah,"|                PROGRAM SATUAN WAKTU            |",0dh,0ah,"++++++++++++++++++++++++++++++++++++++++++++++++++",0dh,0ah,"| 1. Konversi Detik                              |",0dh,0ah,"| 2. Konversi Jam                                |",0dh,0ah,"| Masukkan angka 1 atau 2 untuk memilih operasi: $"
        psn2:    db      0dh,0ah,"++++++++++++++++++++++++++++++++++++++++++++++++++",0dh,0ah,"| Masukkan Angka Pertama : $"
        psn3:    db      0dh,0ah,"| Masukkan Angka Kedua : $"
        psn4:    db      0dh,0ah,"++++++++++++++++++++++++++++++++++++++++++++++++++",0dh,0ah,"| Error $" 
        psn5:    db      0dh,0ah,"|",0dh,0ah,"| Hasil : $"                                                                                             
        psn6:    db      0dh,0ah,'| Terimakasih telah menggunakan Program ini! Tekan apa saja untuk keluar... ', 0dh,0ah, '$'
start:  mov ah,9
        mov dx, offset psn ;mencetak pesan pertama dimana user bisa memilih peng-operasian dengan int 21h
        int 21h
        mov ah,0                       
        int 16h  ;int 16h digunakan untuk meregister inputan user
        cmp al,31h ;inputan akan di simpan, lalu di bandingkan dengan 1. Detik..........
        je detik
        cmp al,32h
        je jam
        mov ah,09h
        mov dx, offset psn4
        int 21h
        mov ah,0
        int 16h
        jmp start
        
detik:
            mov ah,09h
            mov dx, offset psn2   ;mencetak persan untuk memasukkan angka pertama menggunakan int 21h
            int 21h
            mov cx,0              ;dipanggil InputNo untuk menghandle inputan user dan mengambil angka secara terpisah
            call InputNo
            push dx               ;move ke cx 0 untuk nanti di incrementkan di InputNo
            mov ah,9
            mov dx, offset psn3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset psn5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit  

InputNo:    
        mov ah,0
        int 16h ;lalu int 16h digunakan untuk membaca inputan     
        mov dx,0  
        mov bx,1 
        cmp al,0dh ;inputan akan di simpan di al, lalu akan di bandingkan dengan 0d yang merujuk ke enter untuk mengetahui apakah user telah selesai memasukkan angka atau tidak
        je FormNo ;jika enter di tekan maka angka telah di simpan didalam stack, code akan kembali menggunakan FormNo
        sub ax,30h ;30 akan dikurangkan dari nilai ax untuk di convert ke nilai inputan dari ascii ke desimal
        call ViewNo ;ViewNo dipanggil untuk melihat inputan ke layar
        mov ah,0 ;mov 0 ke ah sebelum push ax ke stack karena hanya diperlukan nilai di al
        push ax  ;push isi dari ax ke stack
        inc cx   ;menjumlahkan 1 ke cx sebagai counter untuk berapa digit angkanya
        jmp InputNo ;jump kembali ke angka inputan untuk mengambil angka lain atau memencet enter          
   
;angka-angka ini akan di ambil masing-masing jadi angka-angka ini harus dibentuk dan disimpan menjadi satu bit
FormNo:     
        pop ax  
        push dx      
        mul bx
        pop dx
        add dx,ax
        mov ax,bx       
        mov bx,10
        push dx
        mul bx
        pop dx
        mov bx,ax
        dec cx
        cmp cx,0
        jne FormNo
        ret   

View:  
        mov ax,dx
        mov dx,0
        div cx 
        call ViewNo
        mov bx,dx 
        mov dx,0
        mov ax,cx 
        mov cx,10
        div cx
        mov dx,bx 
        mov cx,ax
        cmp ax,0
        jne View
        ret

ViewNo:    
        push ax ;push ax dan dx ke dalam stack, lalu akan di pop kembali
        push dx ;akan di stack sehingga tidak mengganggu isinya
        mov dx,ax ;mov ke nilai dx yang ditunggu int 21h adalah output yang akan di simpan didalamnya
        add dl,30h ;menambah 30 pada nilainya untuk mengconvert kembali ke ascii
        mov ah,2
        int 21h
        pop dx  
        pop ax
        ret      
   
exit:   
        mov dx,offset psn6
        mov ah, 09h
        int 21h  

        mov ah, 0
        int 16h

        ret            
                       
jam:   
        mov ah,09h
        mov dx, offset psn2
        int 21h
        mov cx,0
        call InputNo
        push dx
        mov ah,9
        mov dx, offset psn3
        int 21h 
        mov cx,0
        call InputNo
        pop bx
        mov ax,bx
        mov cx,dx
        mov dx,0
        mov bx,0
        div cx
        mov bx,dx
        mov dx,ax
        push bx 
        push dx 
        mov ah,9
        mov dx, offset psn5
        int 21h
        mov cx,10000
        pop dx
        call View
        pop bx
        cmp bx,0
        je exit 
        jmp exit  





     






