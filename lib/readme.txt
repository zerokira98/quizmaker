documentation

quiz struktur direktori:

folder [uniqueid][judulquiz]
 - quiz.json
 - folder [resource]
  - audio
  - img

///---------------------
struktur quiz.json:

{
  "judul": "Judul Quiz",
  "id":"judul+datetimeNow",
  "quizs": [
    {
      "pertanyaan": "rich text pertanyaan",
      "id": "randomGenerateString+indexOnCreation",
      "img":["id.png"],
      "audio":"audio.mp3",
      "jawaban": [
        {
          "text": "isi text jawaban",
          "img": "id.png",
          "id": "hash(pertanyaanId+indexOnCreation+bool)"
        },
        {
          "text": "isi text jawaban2",
          "img": "id.png",
          "id": "hash(pertanyaanId+indexOnCreation+bool)"
        }
      ]
    }
  ]
}
notes:
    bool == true => jawaban benar

///-----------------------
answer.json yang akan dikirim peserta quiz

{
    "quizId":quizId,
    "answers":[
        {
            "quiestionId":questionId,
            "selectedId":jawabanId
        },
        {
            "quiestionId":questionId,
            "selectedId":jawabanId
        }
    ]
}
////-------------------------
score is gotten by comparing quiz.json & answer.json 

