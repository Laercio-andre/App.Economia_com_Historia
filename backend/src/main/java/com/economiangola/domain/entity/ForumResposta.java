// src/main/java/com/economiangola/domain/entity/ForumResposta.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "forum_respostas")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ForumResposta extends SoftDeletableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topico_id", nullable = false)
    private ForumTopico topico;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id", nullable = false)
    private Usuario autor;

    @Column(name = "corpo", nullable = false, columnDefinition = "TEXT")
    private String corpo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pai_id")
    private ForumResposta pai;

    @Column(name = "aceite", nullable = false)
    @Builder.Default
    private Boolean aceite = false;

    @OneToMany(mappedBy = "pai", cascade = CascadeType.ALL)
    @Builder.Default
    private List<ForumResposta> filhos = new ArrayList<>();

    @OneToMany(mappedBy = "forumResposta", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ForumRespostaLike> likes = new ArrayList<>();
}
