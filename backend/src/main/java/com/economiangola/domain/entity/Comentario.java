// src/main/java/com/economiangola/domain/entity/Comentario.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "comentarios")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Comentario extends SoftDeletableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id", nullable = false)
    private Conteudo conteudo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "texto", nullable = false, length = 2000)
    private String texto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pai_id")
    private Comentario pai;

    @OneToMany(mappedBy = "pai", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Comentario> filhos = new ArrayList<>();

    @OneToMany(mappedBy = "comentario", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ComentarioLike> likes = new ArrayList<>();
}
